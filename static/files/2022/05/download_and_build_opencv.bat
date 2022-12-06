@ECHO OFF
ECHO -- Downloading OpenCV Source Code --
wget https://github.com/opencv/opencv/archive/refs/tags/4.6.0.zip -O opencv-4.6.0.zip
IF NOT ERRORLEVEL 0 GOTO :end
7z x opencv-4.6.0.zip
IF NOT ERRORLEVEL 0 GOTO :end
wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.6.0.zip -O opencv_contrib-4.6.0.zip
IF NOT ERRORLEVEL 0 GOTO :end
7z x opencv_contrib-4.6.0.zip
IF NOT ERRORLEVEL 0 GOTO :end
SET "USERHOME=%USERPROFILE:\=/%"
SET OPENCV_SRC_DIR=%cd%/opencv-4.6.0
SET OPENCV_CONTRIB_SRC_DIR=%cd%/opencv_contrib-4.6.0
SET OPENCV_BUILD_DIR=%cd%/opencv-build
SET SCOOP_ROOT=%USERHOME%/scoop
SET PYTHON_PATH=%SCOOP_ROOT%/apps/python310/current
SET PYTHON_LIBRARY=%PYTHON_PATH%/libs/python310.lib
SET PYTHON_VERSION=3.10
SET CUDA_SDK_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.7"
@REM CUDA_ARCH=8.6 for GeForce RTX 3080 Ti
@REM Choice value for your GPU with: https://developer.nvidia.com/cuda-gpus
SET CUDA_ARCH=8.6
ECHO -- Starting OpenCV Configuration --
call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat"
@REM If you want to use the Visual Studio 2019 MSVC:
@REM call "C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Auxiliary/Build/vcvars64.bat" -vcvars_ver=14.29
cmake.exe ^
-S%OPENCV_SRC_DIR% ^
-B%OPENCV_BUILD_DIR% ^
-DCMAKE_INSTALL_PREFIX=%OPENCV_BUILD_DIR%/install ^
-DOPENCV_EXTRA_MODULES_PATH=%OPENCV_CONTRIB_SRC_DIR%/modules ^
-DPYTHON3_EXECUTABLE=%PYTHON_PATH%/python.exe ^
-DPYTHON3_INCLUDE_DIR=%PYTHON_PATH%/include ^
-DPYTHON3_LIBRARY=%PYTHON_LIBRARY% ^
-DPYTHON3_NUMPY_INCLUDE_DIRS=%PYTHON_PATH%/Lib/site-packages/numpy/core/include ^
-DPYTHON3_PACKAGES_PATH=%PYTHON_PATH%/Lib/site-packages ^
-DPYTHON_INCLUDE_DIRS=%PYTHON_PATH%/include ^
-DPYTHON_LIBRARIES=%PYTHON_LIBRARY% ^
-DCUDA_TOOLKIT_ROOT_DIR=%CUDA_SDK_DIR% ^
-DENABLE_FAST_MATH=ON ^
-DCUDA_FAST_MATH=ON ^
-DWITH_CUDA=ON ^
-DWITH_CUDNN=ON ^
-DOPENCV_DNN_CUDA=ON ^
-DCUDA_ARCH_BIN=%CUDA_ARCH% ^
-DCUDA_ARCH_PTX=%CUDA_ARCH% ^
-DWITH_OPENGL=ON ^
-DWITH_GSTREAMER=ON ^
-DWITH_FREETYPE=ON ^
-DBUILD_opencv_python3=ON ^
-DCMAKE_CONFIGURATIONS_TYPES=Release ^
-DCMAKE_BUILD_TYPE=Release ^
-DOPENCV_PYTHON3_VERSION=%PYTHON_VERSION% ^
-DBUILD_TESTS=OFF ^
-DBUILD_PERF_TESTS=OFF ^
-DBUILD_JAVA=OFF ^
-DBUILD_opencv_objc_bindings_generator=OFF ^
-DBUILD_opencv_js=OFF ^
-GNinja ^
-DBUILD_opencv_world=ON
IF NOT ERRORLEVEL 0 GOTO :end
IF NOT ERRORLEVEL 0 GOTO :end
ECHO -- OpenCV Configuration has finished, press any key to proceeding to build phase... --
PAUSE
cmake.exe --build %OPENCV_BUILD_DIR% --target install
IF NOT ERRORLEVEL 0 GOTO :end
ECHO -- OpenCV Build has finished, press any key to install... --
PAUSE
pip uninstall opencv-python opencv-contrib-python
IF NOT ERRORLEVEL 0 GOTO :end
COPY %OPENCV_BUILD_DIR%/lib/python3/cv2.cp310-win_amd64.pyd %PYTHON_PATH%/Lib/site-packages/cv2.cp310-win_amd64.pyd /Y
IF NOT ERRORLEVEL 0 GOTO :end
COPY %OPENCV_BUILD_DIR%/install/x64/vc17/bin/*.dll %PYTHON_PATH%/Scripts /Y
IF NOT ERRORLEVEL 0 GOTO :end
pip install opencv-contrib-python
IF NOT ERRORLEVEL 0 GOTO :end
ECHO -- all finished, press any key to exit... --
PAUSE
:end