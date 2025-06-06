#ifndef BACKEND_H
#define BACKEND_H

#include <string>
#include <vector>
#include "FFAudioPlayer.h"

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libswresample/swresample.h>
}

#include <AudioToolbox/AudioToolbox.h>

using string = std::string;

struct FFPlayer
{
public:
    FFPlayer();
    ~FFPlayer();

    void load(const string &url);
    void startQueue(const string &deviceUID);
    void pauseQueue();
    void stopQueue();

    AudioQueueRef queue() { return mQueue; }

    FFPlayerState state() const;
    void          setStateCallback(FFPlayer_state_callback cb, void *userData);

    string nowPlaing() const;
    void   setNowPlayingCallback(FFPlayer_now_plaing_callback cb, void *userData);

    int    error() const;
    string errorString() const;

    int getVolume(float *res);
    int setVolume(float value);

private:
    AVFormatContext *mFormatContext = nullptr;
    AVCodecContext  *mCodecContext  = nullptr;
    SwrContext      *mSwrContext    = nullptr;
    AVFrame         *mFrame         = nullptr;
    AVPacket        *mPacket        = nullptr;
    AudioQueueRef    mQueue         = nullptr;

    AVChannelLayout mOutLayout;

    int            mStreamIndex   = -1;
    int            mOutSampleRate = 0;
    int            mOutChannels   = 0;
    AVSampleFormat mOutFmt        = AV_SAMPLE_FMT_S16;

    std::mutex           mPcmMutex;
    std::vector<uint8_t> mPcmBuffer;

    string             mPrvNowPlaing;
    mutable std::mutex mNowPlaingMutex;
    string             mNowPlaing;

    mutable std::mutex mErrorMutex;
    int                mErrorCode = 0;
    string             mErrorString;

    mutable std::mutex mStateMutex;
    FFPlayerState      mState = FFPlayer_Stoped;

    FFPlayer_now_plaing_callback mNowPlayingCallback = nullptr;
    void                        *mNowPlayingUserData = nullptr;

    FFPlayer_state_callback mStateCallback = nullptr;
    void                   *mStateUserData = nullptr;

    AudioStreamBasicDescription makeASBD(AVSampleFormat outFmt, int outChannels, int outSampleRate);

    static void fillAudioBuffer(void *userData, AudioQueueRef outAQ, AudioQueueBufferRef outBuffer);

    void setState(FFPlayerState value);

    void setNowPlaing(const std::string &value);

    void setError(int errorCode, const std::string &errorMessage);
    void setFFError(int errorCode, const std::string &errorMessage);

    void setQueueDeviceUID();
};

#endif // BACKEND_H
