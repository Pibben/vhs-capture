VIDEO_CAPABILITIES="video/x-raw,format=YUY2,framerate=25/1,width=720,height=576,pixel-aspect-ratio=54/59"
#VIDEO_CAPABILITIES="video/x-raw"
AUDIO_DEVICE=hw:CARD=Cx231xxAudio,DEV=0
AUDIO_CAPABILITIES="audio/x-raw,rate=32000,channels=2"
TV_NORM=PAL-B
#VIDEO_INPUT=videotestsrc
#VIDEO_INPUT="v4l2src device=/dev/video0"
VIDEO_INPUT="v4l2src device=/dev/video2 do-timestamp=true norm=PAL-B"
#AUDIO_INPUT=audiotestsrc
AUDIO_INPUT="alsasrc device=$AUDIO_DEVICE do-timestamp=true"

#gst-launch-1.0 -vvv \
#v4l2src device="$VIDEO_DEVICE" do-timestamp=true norm="$TV_NORM" pixel-aspect-ratio=1 \
#        ! $VIDEO_CAPABILITIES \
#        ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#        ! mux. \
#	alsasrc device="$AUDIO_DEVICE" do-timestamp=true \
#        ! $AUDIO_CAPABILITIES \
#        ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#        ! mux. \
#        matroskamux name=mux \
#       ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
#        ! filesink location=test.mkv

#gst-launch-1.0 -vvv videotestsrc ! $VIDEO_CAPABILITIES ! videoconvert ! xvimagesink

gst-launch-1.0 -vvv $VIDEO_INPUT \
        ! $VIDEO_CAPABILITIES \
	! tee name=foo \
	! videoconvert ! avenc_huffyuv \
	! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
	! mux. \
	$AUDIO_INPUT \
	! lamemp3enc \
	! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
	! mux. \
	matroskamux name=mux \
	! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 \
	! filesink location=test.mkv \
	foo. ! videoconvert ! xvimagesink
