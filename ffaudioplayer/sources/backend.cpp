#include "backend.h"
#include <iostream>

using namespace std;

static constexpr int    NUM_BUFFERS = 50;
static constexpr size_t BUFFER_SIZE = 8192;

class PacketRAII
{
    AVPacket *mPacket = nullptr;

public:
    PacketRAII(AVPacket *packet) :
        mPacket(packet) { }

    ~PacketRAII() { av_packet_unref(mPacket); }
};

class RaiiFreep
{
    void *mPtr = nullptr;

public:
    RaiiFreep(void *ptr) :
        mPtr(ptr) { }

    ~RaiiFreep() { av_freep(&mPtr); }
};

/**************************************
 *
 **************************************/
FFPlayer::FFPlayer()
{
    mPcmBuffer.reserve(BUFFER_SIZE);
    setState(FFPlayer_Stoped);
}

/**************************************
 *
 **************************************/
FFPlayer::~FFPlayer()
{
    if (mQueue) {
        AudioQueueStop(mQueue, true);
        AudioQueueDispose(mQueue, true);
    }

    // clang-format off
    if (mSwrContext)            swr_free(&mSwrContext);
    if (mCodecContext)          avcodec_free_context(&mCodecContext);
    if (mFormatContext)         avformat_close_input(&mFormatContext);
    if (mOutLayout.nb_channels) av_channel_layout_uninit(&mOutLayout);
    if (mPacket)                av_packet_free(&mPacket);
    if (mFrame)                 av_frame_free(&mFrame);
    // clang-format on
}

/**************************************
 *
 **************************************/
void FFPlayer::load(const string &url)
{
    int err = 0;
    setState(FFPlayer_Loading);

    AVDictionary *options = nullptr;
    if ((err = av_dict_set(&options, "icy", "1", 0)) < 0) {
        setFFError(err, "Error calling av_dict_set");
        return;
    }

    if ((err = avformat_open_input(&mFormatContext, url.c_str(), nullptr, &options)) < 0) {
        av_dict_free(&options);
        setFFError(err, "Error calling avformat_open_input");
        return;
    }
    av_dict_free(&options);

    if ((err = avformat_find_stream_info(mFormatContext, nullptr)) < 0) {
        setFFError(err, "Error calling avformat_find_stream_info");
        return;
    }

    // Find the first audio stream
    mStreamIndex = av_find_best_stream(mFormatContext, AVMEDIA_TYPE_AUDIO, -1, -1, nullptr, 0);
    if (mStreamIndex < 0) {
        setError(NoStreamFoundError, "No audio stream found.");
        return;
    }

    const AVCodec *codec = avcodec_find_decoder(mFormatContext->streams[mStreamIndex]->codecpar->codec_id);
    if (!codec) {
        setError(NoCodecFoundError, "No input codec found.");
        return;
    }

    mCodecContext = avcodec_alloc_context3(codec);
    if (!mCodecContext) {
        setError(AlocError_avcodec, "Error calling avcodec_alloc_context3");
        return;
    }
    mCodecContext->pkt_timebase = mFormatContext->streams[mStreamIndex]->time_base;

    if ((err = avcodec_parameters_to_context(mCodecContext, mFormatContext->streams[mStreamIndex]->codecpar)) < 0) {
        setFFError(err, "Error calling avcodec_parameters_to_context");
        return;
    }

    if ((err = avcodec_open2(mCodecContext, codec, nullptr)) < 0) {
        setFFError(err, "Error calling avcodec_open2");
        return;
    }

    // init OutputStream() .................

    if ((mFrame = av_frame_alloc()) == nullptr) {
        setError(AlocError_avframe, "Error calling av_frame_alloc");
        return;
    }

    if ((mPacket = av_packet_alloc()) == nullptr) {
        setError(AlocError_avpacket, "Error calling av_packet_alloc");
        return;
    }

    // Define output format
    mOutSampleRate = mCodecContext->sample_rate;
    mOutChannels   = std::min(2, mCodecContext->ch_layout.nb_channels);
    mOutFmt        = AV_SAMPLE_FMT_FLT;

    av_channel_layout_default(&mOutLayout, mOutChannels);

    err = swr_alloc_set_opts2(&mSwrContext,
                              &mOutLayout, mOutFmt, mOutSampleRate,
                              &mCodecContext->ch_layout, mCodecContext->sample_fmt, mCodecContext->sample_rate,
                              0, nullptr);
    if (err < 0) {
        setFFError(err, "Error calling swr_alloc_set_opts2");
        return;
    }

    if ((err = swr_init(mSwrContext)) < 0) {
        setFFError(err, "Error calling swr_init");
        return;
    }

    AudioStreamBasicDescription format = makeASBD(mOutFmt, mOutChannels, mOutSampleRate);

    if ((err = AudioQueueNewOutput(&format, fillAudioBuffer, this, nullptr, nullptr, 0, &mQueue)) < 0) {
        setError(AlocError_AudioQueue, "Error calling AudioQueueNewOutput");
        return;
    }

    AudioQueueBufferRef buffers[NUM_BUFFERS];
    for (int i = 0; i < NUM_BUFFERS; ++i) {
        err = AudioQueueAllocateBuffer(mQueue, BUFFER_SIZE, &buffers[i]);
        fillAudioBuffer(this, mQueue, buffers[i]);
    }
}

/**************************************
 *
 **************************************/
AudioStreamBasicDescription FFPlayer::makeASBD(AVSampleFormat outFmt, int outChannels, int outSampleRate)
{
    AudioStreamBasicDescription format = {};
    format.mSampleRate                 = outSampleRate;
    format.mFormatID                   = kAudioFormatLinearPCM;

    // sample type detection
    switch (outFmt) {
        case AV_SAMPLE_FMT_FLT:
        case AV_SAMPLE_FMT_FLTP:
            format.mFormatFlags    = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked;
            format.mBitsPerChannel = 32;
            break;

        case AV_SAMPLE_FMT_S16:
        case AV_SAMPLE_FMT_S16P:
            format.mFormatFlags    = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
            format.mBitsPerChannel = 16;
            break;

        case AV_SAMPLE_FMT_S32:
        case AV_SAMPLE_FMT_S32P:
            format.mFormatFlags    = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
            format.mBitsPerChannel = 32;
            break;

        case AV_SAMPLE_FMT_U8:
        case AV_SAMPLE_FMT_U8P:
            format.mFormatFlags    = kAudioFormatFlagIsPacked;
            format.mBitsPerChannel = 8;
            break;

        default:
            std::cerr << "Unsupported sample format: " << av_get_sample_fmt_name(outFmt) << std::endl;
            format.mFormatFlags    = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
            format.mBitsPerChannel = 16;
            break;
    }

    format.mChannelsPerFrame = outChannels;
    format.mFramesPerPacket  = 1;
    format.mBytesPerFrame    = (format.mBitsPerChannel / 8) * format.mChannelsPerFrame;
    format.mBytesPerPacket   = format.mBytesPerFrame;
    format.mReserved         = 0;

    return format;
}

/**************************************
 *
 **************************************/
void FFPlayer::fillAudioBuffer(void *userData, AudioQueueRef outAQ, AudioQueueBufferRef outBuffer)
{
    FFPlayer                   *ff = static_cast<FFPlayer *>(userData);
    std::lock_guard<std::mutex> lock(ff->mPcmMutex);
    bool                        finished = false;

    while (ff->mPcmBuffer.size() < BUFFER_SIZE) {
        int err = 0;

        err = av_read_frame(ff->mFormatContext, ff->mPacket);
        if (err == AVERROR_EOF) {
            finished = true;
            break;
        }

        if (err < 0) {
            ff->setFFError(err, "Error calling av_read_frame");
            return;
        }

        PacketRAII packetRAII(ff->mPacket);

        AVDictionaryEntry *tag = av_dict_get(ff->mFormatContext->metadata, "StreamTitle", nullptr, 0);
        if (tag && strlen(tag->value) > 0) {
            if (ff->mPrvNowPlaing != tag->value) {
                ff->mPrvNowPlaing = tag->value;
                ff->setNowPlaing(ff->mPrvNowPlaing);
            }
        }

        if (ff->mPacket->stream_index != ff->mStreamIndex) {
            continue;
        }

        if ((err = avcodec_send_packet(ff->mCodecContext, ff->mPacket)) < 0) {
            ff->setFFError(err, "Error calling avcodec_send_packet");
            return;
        }

        err = avcodec_receive_frame(ff->mCodecContext, ff->mFrame);
        if (err == AVERROR_EOF) {
            finished = true;
            break;
        }

        if (err == AVERROR(EAGAIN)) {
            continue;
        }

        if (err < 0) {
            ff->setFFError(err, "Error calling avcodec_receive_frame");
            return;
        }

        int dstNbSamples = av_rescale_rnd(
                swr_get_delay(ff->mSwrContext, ff->mCodecContext->sample_rate) + ff->mFrame->nb_samples,
                ff->mOutSampleRate, ff->mCodecContext->sample_rate, AV_ROUND_UP);

        int      outLinesize;
        uint8_t *outBuf;
        err = av_samples_alloc(&outBuf, &outLinesize, ff->mOutChannels, dstNbSamples, ff->mOutFmt, 0);
        RaiiFreep raiiFreep(outBuf);

        if (err < 0) {
            ff->setFFError(err, "Error calling av_samples_alloc");
            return;
        }

        int samplesConverted = swr_convert(ff->mSwrContext, &outBuf, dstNbSamples, (const uint8_t **)ff->mFrame->data, ff->mFrame->nb_samples);
        if (samplesConverted < 0) {
            ff->setFFError(samplesConverted, "Error calling swr_convert");
            return;
        }

        int outSize = av_samples_get_buffer_size(nullptr, ff->mOutChannels, samplesConverted, ff->mOutFmt, 1);
        if (outSize < 0) {
            ff->setFFError(outSize, "Error calling av_samples_get_buffer_size");
            return;
        }

        size_t sz = ff->mPcmBuffer.size();
        ff->mPcmBuffer.resize(sz + outSize);
        memcpy(ff->mPcmBuffer.data() + sz, outBuf, outSize);
    }

    size_t toCopy                 = std::min(BUFFER_SIZE, ff->mPcmBuffer.size());
    outBuffer->mAudioDataByteSize = toCopy;

    auto *dest = static_cast<uint8_t *>(outBuffer->mAudioData);
    memcpy(dest, ff->mPcmBuffer.data(), toCopy);
    AudioQueueEnqueueBuffer(outAQ, outBuffer, 0, nullptr);

    if (ff->mPcmBuffer.size() > BUFFER_SIZE) {
        memmove(ff->mPcmBuffer.data(), ff->mPcmBuffer.data() + toCopy, ff->mPcmBuffer.size() - toCopy);
    }
    ff->mPcmBuffer.resize(ff->mPcmBuffer.size() - toCopy);

    if (finished) {
        ff->setState(FFPlayer_Stoped);
    }
}

/**************************************
 *
 **************************************/
void FFPlayer::startQueue(const string &deviceUID)
{
    if (!deviceUID.empty()) {
        CFStringRef cfUid = CFStringCreateWithCString(kCFAllocatorDefault, deviceUID.c_str(), kCFStringEncodingUTF8);

        OSStatus err = AudioQueueSetProperty(mQueue, kAudioQueueProperty_CurrentDevice, &cfUid, sizeof(CFStringRef));
        CFRelease(cfUid);
        if (err != noErr) {
            setError(SetVolumeError, "Error setting audio device");
            return;
        }
    }

    int err = AudioQueueStart(mQueue, nullptr);
    if (err != noErr) {
        setError(AudioQueueStartError, "Error calling AudioQueueStart");
        return;
    }

    setState(FFPlayer_Playing);
}

/**************************************
 *
 **************************************/
void FFPlayer::pauseQueue()
{
    int err = AudioQueuePause(mQueue);
    if (err != noErr) {
        setError(AudioQueuePauseError, "Error calling AudioQueuePause");
    }
    setState(FFPlayer_Stoped);
}

/**************************************
 *
 **************************************/
void FFPlayer::stopQueue()
{
    int err = AudioQueueStop(mQueue, true);
    if (err != noErr) {
        setError(AudioQueueStopError, "Error calling AudioQueueStop");
    }
    setState(FFPlayer_Stoped);
}

/**************************************
 *
 **************************************/
FFPlayerState FFPlayer::state() const
{
    if (error() != NoError) {
        return FFPlayer_Error;
    }

    return mState;
}

/**************************************
 *
 **************************************/
void FFPlayer::setState(FFPlayerState value)
{
    const std::lock_guard<std::mutex> locker(mStateMutex);

    FFPlayerState prev = state();

    mState = value;

    if (prev != state()) {
        if (mStateCallback) {
            mStateCallback(mStateUserData, state());
        }
    }
}

/**************************************
 *
 **************************************/
void FFPlayer::setStateCallback(FFPlayer_state_callback cb, void *userData)
{
    mStateCallback = cb;
    mStateUserData = userData;
}

/**************************************
 *
 **************************************/
string FFPlayer::nowPlaing() const
{
    const std::lock_guard<std::mutex> locker(mNowPlaingMutex);
    return mNowPlaing;
}

/**************************************
 *
 **************************************/
void FFPlayer::setNowPlaing(const std::string &value)
{
    const std::lock_guard<std::mutex> locker(mNowPlaingMutex);
    if (mNowPlaing != value) {
        mNowPlaing = value;

        if (mNowPlayingCallback) {
            mNowPlayingCallback(mNowPlayingUserData, mNowPlaing.c_str());
        }
    }
}

/**************************************
 *
 **************************************/
void FFPlayer::setNowPlayingCallback(FFPlayer_now_plaing_callback cb, void *userData)
{
    mNowPlayingCallback = cb;
    mNowPlayingUserData = userData;
}

/**************************************
 *
 **************************************/
int FFPlayer::error() const
{
    const std::lock_guard<std::mutex> locker(mErrorMutex);
    return mErrorCode;
}

/**************************************
 *
 **************************************/
string FFPlayer::errorString() const
{
    const std::lock_guard<std::mutex> locker(mErrorMutex);
    return mErrorString;
}

/**************************************
 *
 **************************************/
void FFPlayer::setError(int errorCode, const std::string &errorMessage)
{
    const std::lock_guard<std::mutex> locker(mErrorMutex);

    FFPlayerState prev = state();

    mErrorCode   = errorCode;
    mErrorString = errorMessage;

    if (prev != state()) {
        if (mStateCallback) {
            mStateCallback(mStateUserData, state());
        }
    }
}

/**************************************
 *
 **************************************/
void FFPlayer::setFFError(int errorCode, const string &errorMessage)
{
    const std::lock_guard<std::mutex> locker(mErrorMutex);
    mErrorCode                     = errorCode;
    static char error_string[1024] = {};
    av_make_error_string(error_string, 1024, errorCode);
    mErrorString = errorMessage + ". error code = " + to_string(errorCode) + " : " + error_string;
}

/**************************************
 *
 **************************************/
int FFPlayer::getVolume(float *res)
{
    return AudioQueueGetParameter(mQueue, kAudioQueueParam_Volume, res);
}

/**************************************
 *
 **************************************/
int FFPlayer::setVolume(float value)
{
    return AudioQueueSetParameter(mQueue, kAudioQueueParam_Volume, value);
}
