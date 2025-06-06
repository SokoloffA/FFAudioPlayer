#include "FFAudioPlayer.h"
#include "backend.h"

extern "C" struct FFPlayer *ffplayer_create()
{
    return new FFPlayer();
}

extern "C" void ffplayer_free(FFPlayer *player)
{
    delete player;
}

extern "C" int ffplayer_load(FFPlayer *player, const char *url)
{
    player->load(url);
    return player->error();
}

int ffplayer_start_queue(FFPlayer *player, const char *device_uid)
{
    player->startQueue(device_uid ? string(device_uid) : "");
    return player->error();
}

int ffplayer_pause_queue(FFPlayer *player)
{
    player->pauseQueue();
    return player->error();
}

int ffplayer_stop_queue(FFPlayer *player)
{
    player->stopQueue();
    return player->error();
}

int ffplayer_get_error(FFPlayer *player)
{
    return player->error();
}

const char *ffplayer_get_error_string(FFPlayer *player)
{
    static thread_local std::string s;
    s = player->errorString();
    return s.c_str();
}

enum FFPlayerState ffplayer_get_state(FFPlayer *player)
{
    return player->state();
}

const char *ffplayer_get_now_plaing(FFPlayer *player)
{
    static thread_local std::string s;
    s = player->nowPlaing();
    return s.c_str();
}

void ffplayer_set_now_plaing_callback(FFPlayer *player, void *user_data, FFPlayer_now_plaing_callback callback)
{
    player->setNowPlayingCallback(callback, user_data);
}

void ffplayer_set_state_callback(struct FFPlayer *player, void *user_data, FFPlayer_state_callback callback)
{
    player->setStateCallback(callback, user_data);
}

int ffplayer_get_volume(FFPlayer *player, float *value)
{
    return player->getVolume(value);
}

int ffplayer_set_volume(FFPlayer *player, float value)
{
    return player->setVolume(value);
}

void ffplayer_set_log_level(FFPlayerLogLevel level)
{
    av_log_set_level(level);
}

void ffplayer_set_log_callback(FFPlayer_log_callback callback)
{
    av_log_set_callback(callback);
}
