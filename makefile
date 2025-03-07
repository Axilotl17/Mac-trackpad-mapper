LIBS=-F/System/Library/PrivateFrameworks -framework MultitouchSupport \
	 -framework CoreFoundation \
	 -framework Carbon

BUILD_DIR=build
UTIL=trackpad_mapper_util
TARGET=trackpad_mapper
APP="Trackpad Mapper.app"

all:
	if [[ ! -e ${BUILD_DIR} ]]; then mkdir -p ${BUILD_DIR}/bin; fi
	make util
	make app
	make bundle

release:
	if [[ ! -e ${BUILD_DIR} ]]; then mkdir -p ${BUILD_DIR}/bin; fi
	make util_release
	make app_release
	make bundle

settings.h:
	@if [[ ! -e settings.h ]]; then cp settings.def.h settings.h; fi

util:
	make settings.h
	gcc ${LIBS} ${UTIL}.c -o ${BUILD_DIR}/bin/${UTIL} -g

util_release:
	make settings.h
	gcc ${LIBS} ${UTIL}.c -o ${BUILD_DIR}/bin/${UTIL} -O3

app:
	swiftc ${TARGET}.swift -o ${BUILD_DIR}/bin/${TARGET} -g

app_release:
	swiftc ${TARGET}.swift -o ${BUILD_DIR}/bin/${TARGET} -O

bundle:
	@if [[ ! -e ${BUILD_DIR}/${APP} ]]; then \
		echo Creating app bundle; \
		mkdir -p ${BUILD_DIR}/${APP}/Contents/MacOS; \
		echo done; \
	fi
	@cp -R Resources ${BUILD_DIR}/${APP}/Contents/Resources
	@cp Info.plist ${BUILD_DIR}/${APP}/Contents
	@cp ${BUILD_DIR}/bin/${UTIL} ${BUILD_DIR}/${APP}/Contents/MacOS
	@cp ${BUILD_DIR}/bin/${TARGET} ${BUILD_DIR}/${APP}/Contents/MacOS

install:
	cp -R ${BUILD_DIR}/${APP} /Applications

install_util_update:
	cp ${BUILD_DIR}/bin/${UTIL} /Applications/${APP}/Contents/MacOS
