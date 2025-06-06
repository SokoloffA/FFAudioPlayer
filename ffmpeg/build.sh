#!/bin/bash

set -euo pipefail

CONFIGURE_FLAGS+=" --prefix=${ROOT_DIR}"    # install in PREFIX [$prefix_default]
#CONFIGURE_FLAGS+=" --quiet"                 # Suppress showing informative output
CONFIGURE_FLAGS+=" --fatal-warnings"        # fail if any configure warning is generated
CONFIGURE_FLAGS+=" --logfile=config.log"    # log tests and output to FILE [ffbuild/config.log]

# Configuration options:
CONFIGURE_FLAGS+=" --enable-static"        # do not build static libraries [no]
CONFIGURE_FLAGS+=" --disable-shared"         # build shared libraries [no]


CONFIGURE_FLAGS+=" --disable-all"
CONFIGURE_FLAGS+=" --disable-programs"


CONFIGURE_FLAGS+=" --enable-avformat"
CONFIGURE_FLAGS+=" --enable-avcodec"
CONFIGURE_FLAGS+=" --enable-avutil"
CONFIGURE_FLAGS+=" --enable-swresample"

# Protocols ...........................
CONFIGURE_FLAGS+=" --enable-protocol=async"
CONFIGURE_FLAGS+=" --enable-protocol=cache"
CONFIGURE_FLAGS+=" --enable-protocol=concat"
CONFIGURE_FLAGS+=" --enable-protocol=concatf"
CONFIGURE_FLAGS+=" --enable-protocol=crypto"
CONFIGURE_FLAGS+=" --enable-protocol=data"
CONFIGURE_FLAGS+=" --enable-protocol=fd"
CONFIGURE_FLAGS+=" --enable-protocol=ffrtmphttp"
CONFIGURE_FLAGS+=" --enable-protocol=file"
CONFIGURE_FLAGS+=" --enable-protocol=ftp"
CONFIGURE_FLAGS+=" --enable-protocol=gopher"
CONFIGURE_FLAGS+=" --enable-protocol=gophers"
CONFIGURE_FLAGS+=" --enable-protocol=hls"
CONFIGURE_FLAGS+=" --enable-protocol=http"
CONFIGURE_FLAGS+=" --enable-protocol=httpproxy"
CONFIGURE_FLAGS+=" --enable-protocol=https"
CONFIGURE_FLAGS+=" --enable-protocol=icecast"
CONFIGURE_FLAGS+=" --enable-protocol=ipfs_gateway"
CONFIGURE_FLAGS+=" --enable-protocol=ipns_gateway"
CONFIGURE_FLAGS+=" --enable-protocol=md5"
CONFIGURE_FLAGS+=" --enable-protocol=mmsh"
CONFIGURE_FLAGS+=" --enable-protocol=mmst"
CONFIGURE_FLAGS+=" --enable-protocol=pipe"
CONFIGURE_FLAGS+=" --enable-protocol=prompeg"
CONFIGURE_FLAGS+=" --enable-protocol=rtmp"
CONFIGURE_FLAGS+=" --enable-protocol=rtmps"
CONFIGURE_FLAGS+=" --enable-protocol=rtmpt"
CONFIGURE_FLAGS+=" --enable-protocol=rtmpts"
CONFIGURE_FLAGS+=" --enable-protocol=rtp"
CONFIGURE_FLAGS+=" --enable-protocol=srtp"
CONFIGURE_FLAGS+=" --enable-protocol=subfile"
CONFIGURE_FLAGS+=" --enable-protocol=tcp"
CONFIGURE_FLAGS+=" --enable-protocol=tee"
CONFIGURE_FLAGS+=" --enable-protocol=tls"
CONFIGURE_FLAGS+=" --enable-protocol=udp"
CONFIGURE_FLAGS+=" --enable-protocol=udplite"
CONFIGURE_FLAGS+=" --enable-protocol=unix"


# Demuxers ............................
CONFIGURE_FLAGS+=" --enable-demuxer=aac"
CONFIGURE_FLAGS+=" --enable-demuxer=mp3"
CONFIGURE_FLAGS+=" --enable-demuxer=hls"
CONFIGURE_FLAGS+=" --enable-demuxer=flac"
CONFIGURE_FLAGS+=" --enable-demuxer=ogg"
CONFIGURE_FLAGS+=" --enable-demuxer=mpegts"
CONFIGURE_FLAGS+=" --enable-demuxer=wav"


# Decoders ............................
CONFIGURE_FLAGS+=" --enable-decoder=aac"                  # AAC (Advanced Audio Coding)
CONFIGURE_FLAGS+=" --enable-decoder=aac_at"               # aac (AudioToolbox) (codec aac)
CONFIGURE_FLAGS+=" --enable-decoder=aac_fixed"            # AAC (Advanced Audio Coding) (codec aac)
CONFIGURE_FLAGS+=" --enable-decoder=aac_latm"             # AAC LATM (Advanced Audio Coding LATM syntax)
CONFIGURE_FLAGS+=" --enable-decoder=ac3"                  # ATSC A/52A (AC-3)
CONFIGURE_FLAGS+=" --enable-decoder=ac3_at"               # ac3 (AudioToolbox) (codec ac3)
CONFIGURE_FLAGS+=" --enable-decoder=ac3_fixed"            # ATSC A/52A (AC-3) (codec ac3)
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_4xm"            # ADPCM 4X Movie
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_adx"            # SEGA CRI ADX ADPCM
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_afc"            # ADPCM Nintendo Gamecube AFC
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_agm"            # ADPCM AmuseGraphics Movie
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_aica"           # ADPCM Yamaha AICA
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_argo"           # ADPCM Argonaut Games
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ct"             # ADPCM Creative Technology
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_dtk"            # ADPCM Nintendo Gamecube DTK
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea"             # ADPCM Electronic Arts
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea_maxis_xa"    # ADPCM Electronic Arts Maxis CDROM XA
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea_r1"          # ADPCM Electronic Arts R1
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea_r2"          # ADPCM Electronic Arts R2
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea_r3"          # ADPCM Electronic Arts R3
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ea_xas"         # ADPCM Electronic Arts XAS
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_acorn"      # ADPCM IMA Acorn Replay
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_alp"        # ADPCM IMA High Voltage Software ALP
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_amv"        # ADPCM IMA AMV
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_apc"        # ADPCM IMA CRYO APC
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_apm"        # ADPCM IMA Ubisoft APM
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_cunning"    # ADPCM IMA Cunning Developments
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_dat4"       # ADPCM IMA Eurocom DAT4
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_dk3"        # ADPCM IMA Duck DK3
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_dk4"        # ADPCM IMA Duck DK4
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_ea_eacs"    # ADPCM IMA Electronic Arts EACS
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_ea_sead"    # ADPCM IMA Electronic Arts SEAD
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_iss"        # ADPCM IMA Funcom ISS
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_moflex"     # ADPCM IMA MobiClip MOFLEX
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_mtf"        # ADPCM IMA Capcom's MT Framework
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_oki"        # ADPCM IMA Dialogic OKI
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_qt"         # ADPCM IMA QuickTime
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_qt_at"      # adpcm_ima_qt (AudioToolbox) (codec adpcm_ima_qt)
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_rad"        # ADPCM IMA Radical
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_smjpeg"     # ADPCM IMA Loki SDL MJPEG
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_ssi"        # ADPCM IMA Simon & Schuster Interactive
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_wav"        # ADPCM IMA WAV
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ima_ws"         # ADPCM IMA Westwood
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_ms"             # ADPCM Microsoft
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_mtaf"           # ADPCM MTAF
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_psx"            # ADPCM Playstation
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_sbpro_2"        # ADPCM Sound Blaster Pro 2-bit
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_sbpro_3"        # ADPCM Sound Blaster Pro 2.6-bit
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_sbpro_4"        # ADPCM Sound Blaster Pro 4-bit
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_swf"            # ADPCM Shockwave Flash
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_thp"            # ADPCM Nintendo THP
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_thp_le"         # ADPCM Nintendo THP (little-endian)
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_vima"           # LucasArts VIMA audio
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_xa"             # ADPCM CDROM XA
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_xmd"            # ADPCM Konami XMD
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_yamaha"         # ADPCM Yamaha
CONFIGURE_FLAGS+=" --enable-decoder=adpcm_zork"           # ADPCM Zork
CONFIGURE_FLAGS+=" --enable-decoder=alac"                 # ALAC (Apple Lossless Audio Codec)
CONFIGURE_FLAGS+=" --enable-decoder=alac_at"              # alac (AudioToolbox) (codec alac)
CONFIGURE_FLAGS+=" --enable-decoder=als"                  # MPEG-4 Audio Lossless Coding (ALS) (codec mp4als)
CONFIGURE_FLAGS+=" --enable-decoder=amr_nb_at"            # amr_nb (AudioToolbox) (codec amr_nb)
CONFIGURE_FLAGS+=" --enable-decoder=amrnb"                # AMR-NB (Adaptive Multi-Rate NarrowBand) (codec amr_nb)
CONFIGURE_FLAGS+=" --enable-decoder=amrwb"                # AMR-WB (Adaptive Multi-Rate WideBand) (codec amr_wb)
CONFIGURE_FLAGS+=" --enable-decoder=anull"                # null audio
CONFIGURE_FLAGS+=" --enable-decoder=apac"                 # Marian's A-pac audio
CONFIGURE_FLAGS+=" --enable-decoder=ape"                  # Monkey's Audio
CONFIGURE_FLAGS+=" --enable-decoder=aptx"                 # aptX (Audio Processing Technology for Bluetooth)
CONFIGURE_FLAGS+=" --enable-decoder=aptx_hd"              # aptX HD (Audio Processing Technology for Bluetooth)
CONFIGURE_FLAGS+=" --enable-decoder=atrac1"               # ATRAC1 (Adaptive TRansform Acoustic Coding)
CONFIGURE_FLAGS+=" --enable-decoder=atrac3"               # ATRAC3 (Adaptive TRansform Acoustic Coding 3)
CONFIGURE_FLAGS+=" --enable-decoder=atrac3al"             # ATRAC3 AL (Adaptive TRansform Acoustic Coding 3 Advanced Lossless)
CONFIGURE_FLAGS+=" --enable-decoder=atrac9"               # ATRAC9 (Adaptive TRansform Acoustic Coding 9)
CONFIGURE_FLAGS+=" --enable-decoder=binkaudio_dct"        # Bink Audio (DCT)
CONFIGURE_FLAGS+=" --enable-decoder=binkaudio_rdft"       # Bink Audio (RDFT)
CONFIGURE_FLAGS+=" --enable-decoder=bmv_audio"            # Discworld II BMV audio
CONFIGURE_FLAGS+=" --enable-decoder=bonk"                 # Bonk audio
CONFIGURE_FLAGS+=" --enable-decoder=cbd2_dpcm"            # DPCM Cuberoot-Delta-Exact
CONFIGURE_FLAGS+=" --enable-decoder=comfortnoise"         # RFC 3389 comfort noise generator
CONFIGURE_FLAGS+=" --enable-decoder=cook"                 # Cook / Cooker / Gecko (RealAudio G2)
CONFIGURE_FLAGS+=" --enable-decoder=dca"                  # DCA (DTS Coherent Acoustics) (codec dts)
CONFIGURE_FLAGS+=" --enable-decoder=derf_dpcm"            # DPCM Xilam DERF
CONFIGURE_FLAGS+=" --enable-decoder=dfpwm"                # DFPWM1a audio
CONFIGURE_FLAGS+=" --enable-decoder=dolby_e"              # Dolby E
CONFIGURE_FLAGS+=" --enable-decoder=dsd_lsbf"             # DSD (Direct Stream Digital), least significant bit first
CONFIGURE_FLAGS+=" --enable-decoder=dsd_lsbf_planar"      # DSD (Direct Stream Digital), least significant bit first, planar
CONFIGURE_FLAGS+=" --enable-decoder=dsd_msbf"             # DSD (Direct Stream Digital), most significant bit first
CONFIGURE_FLAGS+=" --enable-decoder=dsd_msbf_planar"      # DSD (Direct Stream Digital), most significant bit first, planar
CONFIGURE_FLAGS+=" --enable-decoder=dsicinaudio"          # Delphine Software International CIN audio
CONFIGURE_FLAGS+=" --enable-decoder=dss_sp"               # Digital Speech Standard - Standard Play mode (DSS SP)
CONFIGURE_FLAGS+=" --enable-decoder=dst"                  # DST (Digital Stream Transfer)
CONFIGURE_FLAGS+=" --enable-decoder=dvaudio"              # Ulead DV Audio
CONFIGURE_FLAGS+=" --enable-decoder=eac3"                 # ATSC A/52B (AC-3, E-AC-3)
CONFIGURE_FLAGS+=" --enable-decoder=eac3_at"              # eac3 (AudioToolbox) (codec eac3)
CONFIGURE_FLAGS+=" --enable-decoder=evrc"                 # EVRC (Enhanced Variable Rate Codec)
CONFIGURE_FLAGS+=" --enable-decoder=fastaudio"            # MobiClip FastAudio
CONFIGURE_FLAGS+=" --enable-decoder=flac"                 # FLAC (Free Lossless Audio Codec)
CONFIGURE_FLAGS+=" --enable-decoder=ftr"                  # FTR Voice
CONFIGURE_FLAGS+=" --enable-decoder=g723_1"               # G.723.1
CONFIGURE_FLAGS+=" --enable-decoder=g729"                 # G.729
CONFIGURE_FLAGS+=" --enable-decoder=gremlin_dpcm"         # DPCM Gremlin
CONFIGURE_FLAGS+=" --enable-decoder=gsm"                  # GSM
CONFIGURE_FLAGS+=" --enable-decoder=gsm_ms"               # GSM Microsoft variant
CONFIGURE_FLAGS+=" --enable-decoder=gsm_ms_at"            # gsm_ms (AudioToolbox) (codec gsm_ms)
CONFIGURE_FLAGS+=" --enable-decoder=hca"                  # CRI HCA
CONFIGURE_FLAGS+=" --enable-decoder=hcom"                 # HCOM Audio
CONFIGURE_FLAGS+=" --enable-decoder=iac"                  # IAC (Indeo Audio Coder)
CONFIGURE_FLAGS+=" --enable-decoder=ilbc"                 # iLBC (Internet Low Bitrate Codec)
CONFIGURE_FLAGS+=" --enable-decoder=ilbc_at"              # ilbc (AudioToolbox) (codec ilbc)
CONFIGURE_FLAGS+=" --enable-decoder=imc"                  # IMC (Intel Music Coder)
CONFIGURE_FLAGS+=" --enable-decoder=interplay_dpcm"       # DPCM Interplay
CONFIGURE_FLAGS+=" --enable-decoder=mace3"                # MACE (Macintosh Audio Compression/Expansion) 3:1
CONFIGURE_FLAGS+=" --enable-decoder=mace6"                # MACE (Macintosh Audio Compression/Expansion) 6:1
CONFIGURE_FLAGS+=" --enable-decoder=metasound"            # Voxware MetaSound
CONFIGURE_FLAGS+=" --enable-decoder=misc4"                # Micronas SC-4 Audio
CONFIGURE_FLAGS+=" --enable-decoder=mlp"                  # MLP (Meridian Lossless Packing)
CONFIGURE_FLAGS+=" --enable-decoder=mp1"                  # MP1 (MPEG audio layer 1)
CONFIGURE_FLAGS+=" --enable-decoder=mp1_at"               # mp1 (AudioToolbox) (codec mp1)
CONFIGURE_FLAGS+=" --enable-decoder=mp1float"             # MP1 (MPEG audio layer 1) (codec mp1)
CONFIGURE_FLAGS+=" --enable-decoder=mp2"                  # MP2 (MPEG audio layer 2)
CONFIGURE_FLAGS+=" --enable-decoder=mp2_at"               # mp2 (AudioToolbox) (codec mp2)
CONFIGURE_FLAGS+=" --enable-decoder=mp2float"             # MP2 (MPEG audio layer 2) (codec mp2)
CONFIGURE_FLAGS+=" --enable-decoder=mp3"                  # MP3 (MPEG audio layer 3)
CONFIGURE_FLAGS+=" --enable-decoder=mp3_at"               # mp3 (AudioToolbox) (codec mp3)
CONFIGURE_FLAGS+=" --enable-decoder=mp3adu"               # ADU (Application Data Unit) MP3 (MPEG audio layer 3)
CONFIGURE_FLAGS+=" --enable-decoder=mp3adufloat"          # ADU (Application Data Unit) MP3 (MPEG audio layer 3) (codec mp3adu)
CONFIGURE_FLAGS+=" --enable-decoder=mp3float"             # MP3 (MPEG audio layer 3) (codec mp3)
CONFIGURE_FLAGS+=" --enable-decoder=mp3on4"               # MP3onMP4
CONFIGURE_FLAGS+=" --enable-decoder=mp3on4float"          # MP3onMP4 (codec mp3on4)
CONFIGURE_FLAGS+=" --enable-decoder=mpc7"                 # Musepack SV7 (codec musepack7)
CONFIGURE_FLAGS+=" --enable-decoder=mpc8"                 # Musepack SV8 (codec musepack8)
CONFIGURE_FLAGS+=" --enable-decoder=msnsiren"             # MSN Siren
CONFIGURE_FLAGS+=" --enable-decoder=nellymoser"           # Nellymoser Asao
CONFIGURE_FLAGS+=" --enable-decoder=on2avc"               # On2 Audio for Video Codec (codec avc)
CONFIGURE_FLAGS+=" --enable-decoder=opus"                 # Opus
CONFIGURE_FLAGS+=" --enable-decoder=osq"                  # OSQ (Original Sound Quality)
CONFIGURE_FLAGS+=" --enable-decoder=paf_audio"            # Amazing Studio Packed Animation File Audio
CONFIGURE_FLAGS+=" --enable-decoder=pcm_alaw"             # PCM A-law / G.711 A-law
CONFIGURE_FLAGS+=" --enable-decoder=pcm_alaw_at"          # pcm_alaw (AudioToolbox) (codec pcm_alaw)
CONFIGURE_FLAGS+=" --enable-decoder=pcm_bluray"           # PCM signed 16|20|24-bit big-endian for Blu-ray media
CONFIGURE_FLAGS+=" --enable-decoder=pcm_dvd"              # PCM signed 16|20|24-bit big-endian for DVD media
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f16le"            # PCM 16.8 floating point little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f24le"            # PCM 24.0 floating point little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f32be"            # PCM 32-bit floating point big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f32le"            # PCM 32-bit floating point little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f64be"            # PCM 64-bit floating point big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_f64le"            # PCM 64-bit floating point little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_lxf"              # PCM signed 20-bit little-endian planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_mulaw"            # PCM mu-law / G.711 mu-law
CONFIGURE_FLAGS+=" --enable-decoder=pcm_mulaw_at"         # pcm_mulaw (AudioToolbox) (codec pcm_mulaw)
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s16be"            # PCM signed 16-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s16be_planar"     # PCM signed 16-bit big-endian planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s16le"            # PCM signed 16-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s16le_planar"     # PCM signed 16-bit little-endian planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s24be"            # PCM signed 24-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s24daud"          # PCM D-Cinema audio signed 24-bit
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s24le"            # PCM signed 24-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s24le_planar"     # PCM signed 24-bit little-endian planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s32be"            # PCM signed 32-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s32le"            # PCM signed 32-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s32le_planar"     # PCM signed 32-bit little-endian planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s64be"            # PCM signed 64-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s64le"            # PCM signed 64-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s8"               # PCM signed 8-bit
CONFIGURE_FLAGS+=" --enable-decoder=pcm_s8_planar"        # PCM signed 8-bit planar
CONFIGURE_FLAGS+=" --enable-decoder=pcm_sga"              # PCM SGA
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u16be"            # PCM unsigned 16-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u16le"            # PCM unsigned 16-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u24be"            # PCM unsigned 24-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u24le"            # PCM unsigned 24-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u32be"            # PCM unsigned 32-bit big-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u32le"            # PCM unsigned 32-bit little-endian
CONFIGURE_FLAGS+=" --enable-decoder=pcm_u8"               # PCM unsigned 8-bit
CONFIGURE_FLAGS+=" --enable-decoder=pcm_vidc"             # PCM Archimedes VIDC
CONFIGURE_FLAGS+=" --enable-decoder=qcelp"                # QCELP / PureVoice
CONFIGURE_FLAGS+=" --enable-decoder=qdm2"                 # QDesign Music Codec 2
CONFIGURE_FLAGS+=" --enable-decoder=qdm2_at"              # qdm2 (AudioToolbox) (codec qdm2)
CONFIGURE_FLAGS+=" --enable-decoder=qdmc"                 # QDesign Music Codec 1
CONFIGURE_FLAGS+=" --enable-decoder=qdmc_at"              # qdmc (AudioToolbox) (codec qdmc)
CONFIGURE_FLAGS+=" --enable-decoder=qoa"                  # QOA (Quite OK Audio)
CONFIGURE_FLAGS+=" --enable-decoder=ralf"                 # RealAudio Lossless
CONFIGURE_FLAGS+=" --enable-decoder=rka"                  # RKA (RK Audio)
CONFIGURE_FLAGS+=" --enable-decoder=roq_dpcm"             # DPCM id RoQ
CONFIGURE_FLAGS+=" --enable-decoder=s302m"                # SMPTE 302M
CONFIGURE_FLAGS+=" --enable-decoder=sbc"                  # SBC (low-complexity subband codec)
CONFIGURE_FLAGS+=" --enable-decoder=sdx2_dpcm"            # DPCM Squareroot-Delta-Exact
CONFIGURE_FLAGS+=" --enable-decoder=shorten"              # Shorten
CONFIGURE_FLAGS+=" --enable-decoder=sipr"                 # RealAudio SIPR / ACELP.NET
CONFIGURE_FLAGS+=" --enable-decoder=siren"                # Siren
CONFIGURE_FLAGS+=" --enable-decoder=smackaud"             # Smacker audio (codec smackaudio)
CONFIGURE_FLAGS+=" --enable-decoder=sol_dpcm"             # DPCM Sol
CONFIGURE_FLAGS+=" --enable-decoder=sonic"                # Sonic
CONFIGURE_FLAGS+=" --enable-decoder=speex"                # Speex
CONFIGURE_FLAGS+=" --enable-decoder=tak"                  # TAK (Tom's lossless Audio Kompressor)
CONFIGURE_FLAGS+=" --enable-decoder=truehd"               # TrueHD
CONFIGURE_FLAGS+=" --enable-decoder=truespeech"           # DSP Group TrueSpeech
CONFIGURE_FLAGS+=" --enable-decoder=tta"                  # TTA (True Audio)
CONFIGURE_FLAGS+=" --enable-decoder=twinvq"               # VQF TwinVQ
CONFIGURE_FLAGS+=" --enable-decoder=vmdaudio"             # Sierra VMD audio
CONFIGURE_FLAGS+=" --enable-decoder=vorbis"               # Vorbis
CONFIGURE_FLAGS+=" --enable-decoder=wady_dpcm"            # DPCM Marble WADY
CONFIGURE_FLAGS+=" --enable-decoder=wavarc"               # Waveform Archiver
CONFIGURE_FLAGS+=" --enable-decoder=wavpack"              # WavPack
CONFIGURE_FLAGS+=" --enable-decoder=wmalossless"          # Windows Media Audio Lossless
CONFIGURE_FLAGS+=" --enable-decoder=wmapro"               # Windows Media Audio 9 Professional
CONFIGURE_FLAGS+=" --enable-decoder=wmav1"                # Windows Media Audio 1
CONFIGURE_FLAGS+=" --enable-decoder=wmav2"                # Windows Media Audio 2
CONFIGURE_FLAGS+=" --enable-decoder=wmavoice"             # Windows Media Audio Voice
CONFIGURE_FLAGS+=" --enable-decoder=ws_snd1"              # Westwood Audio (SND1) (codec westwood_snd1)
CONFIGURE_FLAGS+=" --enable-decoder=xan_dpcm"             # DPCM Xan
CONFIGURE_FLAGS+=" --enable-decoder=xma1"                 # Xbox Media Audio 1
CONFIGURE_FLAGS+=" --enable-decoder=xma2"                 # Xbox Media Audio 2


CONFIGURE_FLAGS+=" --enable-parser=aac"
CONFIGURE_FLAGS+=" --enable-parser=mpegaudio"
CONFIGURE_FLAGS+=" --enable-parser=flac"
CONFIGURE_FLAGS+=" --enable-parser=opus"
CONFIGURE_FLAGS+=" --enable-bsf=aac_adtstoasc"
CONFIGURE_FLAGS+=" --enable-network"

CONFIGURE_FLAGS+=" --disable-appkit"
CONFIGURE_FLAGS+=" --disable-avfoundation"
CONFIGURE_FLAGS+=" --disable-coreimage"
CONFIGURE_FLAGS+=" --enable-securetransport"    # disable Secure Transport, needed for TLS support on OSX if openssl and gnutls are not used [autodetect]
CONFIGURE_FLAGS+=" --disable-iconv"
CONFIGURE_FLAGS+=" --disable-zlib"
CONFIGURE_FLAGS+=" --disable-bzlib"
CONFIGURE_FLAGS+=" --disable-metal"



# Program options:
CONFIGURE_FLAGS+=" --disable-programs"      # do not build command line programs

# The following libraries provide various hardware acceleration features:
CONFIGURE_FLAGS+=" --disable-videotoolbox"    # disable VideoToolbox code [autodetect]

###########################################


lazy_configure ${CONFIGURE_FLAGS}
make -j ${PROC_NUM}
make install
install -m 644 ffbuild/config.sh  "${ROOT_DIR}/share/ffmpeg/config.sh"
install -m 644 ffbuild/config.mak "${ROOT_DIR}/share/ffmpeg/config.mak"
