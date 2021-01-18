# TCodeReader
Barcode and QRCode reader using TCamera from Kastri and ZXing

![Alt text](./LogoImperiumDelphi.png?raw=true "")


Compatible with Embarcadero Delphi. Please note: Only the last two point releases of major releases (e.g. at present that includes 10.3.3 and 10.4.1) are "officially" supported.

Development of TISCodeReader can be helped along with Github Sponsorship, so please consider sponsoring today!

Please star this repo by clicking the Star box in the top right corner if you find it useful!

Due the lack of infrastructure, this component was not tested on iOS.

Devido à falta de infraestrutura este componente não foi testado em iOS.

Customizations on TCamera from Kastri:

Alterações realizadas em TCamera from Kastri:

The YUV_422_888 image format was used on image caputure to utilize the luminance stream, avoinding the conversion to RGBA and after conversion to GrayScale on ZXing.

Uso do padrão YUV_422_888 na captur da imagem para aproveitar o stream de luminância, evitando conversão para RGBA e posterior conversão para GrayScale no ZXing

Customizations on ZXing library:

Alterações realizadas na biblioteca ZXing:

Overload on Scan method, to get a luminance stream, avoinding the conversion to TBitmao do GrayScale

Overload do método Scan, para receber um stream com a luminância, evitando a conversão do TBitmap em GrayScale.

Intructions:

-Use the method Start to open the camera, start preview and find the code in image samples.

-On the event OnScanCodeReady the text of code is ready.

-Use de method Stop to close the camera and stop preview.


Screenshots:


![Alt text](./Screenshot_1.jpg?raw=true "Title1")
![Alt text](./Screenshot_2.jpg?raw=true "Title2")
![Alt text](./Screenshot_3.jpg?raw=true "Title3")


