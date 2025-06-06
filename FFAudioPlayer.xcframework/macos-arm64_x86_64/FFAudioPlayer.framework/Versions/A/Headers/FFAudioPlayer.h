#ifndef FFAUDIOPLAYER_H
#define FFAUDIOPLAYER_H

#include <stdbool.h>
#include <stdarg.h>

#ifdef __cplusplus
extern "C" {
#endif

#define NoError 0
#define AlocError_avframe 1
#define AlocError_avpacket 2
#define AlocError_avcodec 3
#define AlocError_AudioQueue 4
#define NoStreamFoundError 5
#define NoCodecFoundError 6
#define AudioQueueStartError 7
#define AudioQueuePauseError 8
#define AudioQueueStopError 9
#define SetVolumeError 8

enum FFPlayerLogLevel {
    FFPlayer_LogQuiet   = -8, /// Print no output.
    FFPlayer_LogPanic   = 0,  /// Something went really wrong and we will crash now.
    FFPlayer_LogFatal   = 8,  /// Something went wrong and recovery is not possible.
    FFPlayer_LogError   = 16, /// Something went wrong and cannot losslessly be recovered.
    FFPlayer_LogWarning = 24, /// Something somehow does not look correct.
    FFPlayer_LogInfo    = 32, /// Standard information.
    FFPlayer_LogVrbose  = 40, /// Detailed information.
    FFPlayer_LogDebug   = 48, /// Stuff which is only useful for libav* developers.
    FFPlayer_LogTrace   = 56, /// Extremely verbose debugging, useful for libav* development.
};

enum FFPlayerState {
    FFPlayer_Stoped,
    FFPlayer_Loading,
    FFPlayer_Playing,
    FFPlayer_Error,
};

struct FFPlayer;

typedef void (*FFPlayer_state_callback)(void *user_data, enum FFPlayerState state);
typedef void (*FFPlayer_now_plaing_callback)(void *user_data, const char *now_plaing);
typedef void (*FFPlayer_log_callback)(void *, int level, const char *fmt, va_list args);

struct FFPlayer *ffplayer_create();
void             ffplayer_free(struct FFPlayer *player);

int ffplayer_load(struct FFPlayer *player, const char *url);

int ffplayer_start_queue(struct FFPlayer *player, const char *device_uid);
int ffplayer_pause_queue(struct FFPlayer *player);
int ffplayer_stop_queue(struct FFPlayer *player);

int         ffplayer_get_error(struct FFPlayer *player);
const char *ffplayer_get_error_string(struct FFPlayer *player);

enum FFPlayerState ffplayer_get_state(struct FFPlayer *player);
void               ffplayer_set_state_callback(struct FFPlayer *player, void *user_data, FFPlayer_state_callback callback);

const char *ffplayer_get_now_plaing(struct FFPlayer *player);
void        ffplayer_set_now_plaing_callback(struct FFPlayer *player, void *user_data, FFPlayer_now_plaing_callback callback);

int ffplayer_get_volume(struct FFPlayer *player, float *value);
int ffplayer_set_volume(struct FFPlayer *player, float value);

void ffplayer_set_log_level(enum FFPlayerLogLevel level);
void ffplayer_set_log_callback(FFPlayer_log_callback callback);

#ifdef __cplusplus
}
#endif

#endif // FFAUDIOPLAYER_H
