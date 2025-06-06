#include <iostream>
#include <filesystem>
#include <unistd.h>
#include <FFAudioPlayer.h>

using namespace std;

enum Test {
    Wait,
    Skip,
    Fail,
    Pass,
};

using Error = std::runtime_error;

/****************************
 *
 ****************************/
bool printTestStatus(const Test status, const string &testName)
{
    string prefix;
    // clang-format off
    switch (status) {
        case Test::Wait: cout << "WAIT"; break;
        case Test::Skip: cout << "SKIP"; break;
        case Test::Fail: cout << "FAIL"; break;
        case Test::Pass: cout << "PASS"; break;
    }
    // clang-format on

    cout << "    : " << testName << endl;

    // clang-format off
    switch (status) {
        case Test::Wait: return false;
        case Test::Skip: return true;
        case Test::Fail: return false;
        case Test::Pass: return true;
    }
    // clang-format on
    return false;
}

/****************************
 *
 ****************************/
void printUsage(filesystem::path path)
{
    cerr << "Usage " << path.filename() << "[OPTION] URL" << endl;
    cerr << endl;
    cerr << "Options:" << endl;
    cerr << "  --play                       Play the station for real. Do not interrupt after passing the test.";
    cerr << "  --debug                      Print VLC demug messages" << endl;
    cerr << "  --skip-metadata              Skip metadata test" << endl;
}

/****************************
 *
 ****************************/
void nowPlaingChanged(void *, const char *nowPlaing)
{
    cout << "Now plaing: " << nowPlaing << endl;
}

/****************************
 *
 ****************************/
int runPlayer(string url, bool debug)
{
    if (debug) {
        ffplayer_set_log_level(FFPlayer_LogVrbose);
    }

    cout << "*********************************" << endl;
    cout << "Plaing " << url << endl;

    FFPlayer *player = ffplayer_create();
    try {

        if (ffplayer_load(player, url.c_str()) != NoError) {
            throw Error("Error calling ffplayer_load");
        }

        if (ffplayer_start_queue(player, nullptr) != NoError) {
            throw Error("Error calling ffplayer_start_queue");
        }

        ffplayer_set_now_plaing_callback(player, nullptr, nowPlaingChanged);

        while (true) {
            usleep(100 * 1000);

            if (ffplayer_get_error(player) != NoError) {
                throw Error("FFPlayer return error");
            }

            if (ffplayer_get_state(player) != FFPlayer_Playing) {
                break;
            }
        }

        if (ffplayer_stop_queue(player) != NoError) {
            throw Error("Error calling ffplayer_stop_queue");
        }

        ffplayer_free(player);

        return 0;
    }
    catch (const Error &err) {
        cerr << "ERROR: " << err.what() << endl;
        cerr << "player error code:   " << ffplayer_get_error(player) << endl;
        cerr << "player error string: " << ffplayer_get_error_string(player) << endl;
        return 13;
    }
}

/****************************
 *
 ****************************/
int runTest(string url, bool skipConnectionTest, bool skipMetadataTest, bool debug)
{
    Test connectionTest = skipConnectionTest ? Test::Skip : Test::Wait;
    Test metadataTest   = skipMetadataTest ? Test::Skip : Test::Wait;

    if (debug) {
        ffplayer_set_log_level(FFPlayer_LogVrbose);
    }

    cout << "*********************************" << endl;
    cout << "Start testing of " << url << endl;

    FFPlayer *player = ffplayer_create();
    try {

        if (ffplayer_load(player, url.c_str()) != NoError) {
            throw Error("Error calling ffplayer_load");
        }

        if (connectionTest == Test::Wait) {
            connectionTest = Test::Pass;
        }

        if (ffplayer_set_volume(player, 0.0) != NoError) {
            throw Error("Error calling ffplayer_set_volume");
        }

        if (ffplayer_start_queue(player, nullptr) != NoError) {
            throw Error("Error calling ffplayer_start_queue");
        }

        for (int i = 0; i < 10; ++i) {
            usleep(100 * 1000);

            if (ffplayer_get_error(player) != NoError) {
                throw Error("FFPlayer return error");
            }

            string nowPlaing = ffplayer_get_now_plaing(player);
            if (metadataTest == Test::Wait && !nowPlaing.empty()) {
                metadataTest = Test::Pass;
            }

            bool finished = true;
            finished      = finished && connectionTest != Test::Wait;
            finished      = finished && metadataTest != Test::Wait;

            if (finished) {
                break;
            }

            if (ffplayer_get_state(player) != FFPlayer_Playing) {
                break;
            }
        }

        if (ffplayer_stop_queue(player) != NoError) {
            throw Error("Error calling ffplayer_stop_queue");
        }

        ffplayer_free(player);
    }
    catch (const Error &err) {
        cerr << "ERROR: " << err.what() << endl;
        cerr << "player error code:   " << ffplayer_get_error(player) << endl;
        cerr << "player error string: " << ffplayer_get_error_string(player) << endl;
        return 13;
    }

    // clang-format off
    if (connectionTest == Test::Wait) connectionTest = Test::Fail;
    if (metadataTest   == Test::Wait) metadataTest = Test::Fail;
    // clang-format on

    bool ok = true;
    ok      = printTestStatus(connectionTest, "Connect ") && ok;
    ok      = printTestStatus(metadataTest, "Metadata") && ok;

    return ok ? 0 : 2;
}

/****************************
 *
 ****************************/
int main(int argc, char *argv[])
{
    filesystem::path path(argv[0]);
    if (argc < 2) {
        printUsage(path);
        return 100;
    }

    vector<string> urls;
    bool           debug              = false;
    bool           asPlayer           = false;
    bool           skipConnectionTest = false;
    bool           skipMetadataTest   = false;

    for (int i = 1; i < argc; ++i) {
        string arg(argv[i]);

        if (arg.rfind("-", 0) != 0) {
            urls.push_back(arg);
            continue;
        }

        if (arg == "--debug") {
            debug = true;
            continue;
        }

        if (arg == "--skip-metadata") {
            skipMetadataTest = true;
            continue;
        }

        if (arg == "--play") {
            asPlayer = true;
            continue;
        }

        cerr << "unrecognized option '" << arg << "'" << endl;
        printUsage(path);
        return 101;
    }

    int res = 0;
    for (const string &url : urls) {
        if (asPlayer) {
            res += runPlayer(url, debug);
        }
        else {
            res += runTest(url, skipConnectionTest, skipMetadataTest, debug);
        }
    }

    return res;
}
