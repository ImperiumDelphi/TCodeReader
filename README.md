# TISCodeReader
Barcode and QRCode reader using TCamera from Kastri and ZXing

![Alt text](./LogoImperiumDelphi.png?raw=true "")


Compatible with Embarcadero Delphi. Please note: Only the last two point releases of major releases (e.g. at present that includes 10.3.3 and 10.4.1) are "officially" supported.

Development of TISCodeReader can be helped along with Github Sponsorship, so please consider sponsoring today!

Please star this repo by clicking the Star box in the top right corner if you find it useful!

Devido à falta de infraestrutura este componente não foi testado em iOS.

Alterações realizadas em TCamera from Kastri:

Uso do padrão YUV_422_888 na captur da imagem para aproveitar o stream de luminância, evitando conversão para RGBA e posterior conversão para GrayScale no ZXing

Alterações realizadas na biblioteca ZXing:

Overload do método Scan, para receber um stream com a luminância, evitando a conversão do TBitmap em GrayScale.

Intructions:

-Use the method Start for open the camera, start preview and find the code in image samples.
-On the event OnScanCodeReader the text of code is ready.
-Use de method Stop for  close the camera and stop preview.


Screenshots:


![Alt text](./Screenshot_1.jpg?raw=true "Title1")
![Alt text](./Screenshot_2.jpg?raw=true "Title2")
![Alt text](./Screenshot_3.jpg?raw=true "Title3")


