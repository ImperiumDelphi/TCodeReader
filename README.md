# TCodeReader
Barcode and QRCode reader using TCamera from Kastri and ZXing

![Alt text](./LogoImperiumDelphi.png?raw=true "")


Compatible with Embarcadero Delphi. Please note: Only the last two point releases of major releases (e.g. at present that includes 10.3.3 and 10.4.1) are "officially" supported.

Development of TISCodeReader can be helped along with Github Sponsorship, so please consider sponsoring today!

Please star this repo by clicking the Star box in the top right corner if you find it useful!

Due the lack of infrastructure, this component was not tested on iOS.

Customizations on TCamera from Kastri:

The YUV_422_888 image format was used on image caputure to utilize the luminance stream, avoinding the conversion to RGBA and after conversion to GrayScale on ZXing.

Customizations on ZXing library:

Overload Scan method, to get a luminance stream, avoinding the conversion to TBitmap to GrayScale

Intructions:

-Use the method Start to open the camera, start preview and find the code in image samples.

-On the event OnScanCodeReady get the text of code.

-Use the method Stop to close the camera and stop preview.


Screenshots:


![Alt text](./Screenshot_1.jpg?raw=true "")
![Alt text](./Screenshot_2.jpg?raw=true "")
![Alt text](./Screenshot_3.jpg?raw=true "")


