{
  * Copyright 2008 ZXing authors
  *
  * LICENSEd under the Apache LICENSE, Version 2.0 (the "LICENSE");
  * you may not use this file except in compliance with the LICENSE.
  * You may obtain a copy of the LICENSE at
  *
  *      http://www.apache.org/LICENSEs/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the LICENSE is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the LICENSE for the specific language governing permissions and
  * limitations under the LICENSE.

  * Implemented by E. Spelt for Delphi
  * Restructured by K. Gossens
}

unit CodeReader.ZXing.EncodeHintType;

interface

type
  TEncodeHintType = (AZTEC_LAYERS = 15, 
                     CHARACTER_SET = 4, 
					 CODE128_FORCE_CODESET_B = 13,
                     DATA_MATRIX_DEFAULT_ENCODATION = 14,					 
					 DATA_MATRIX_SHAPE = 10, 
					 DISABLE_ECI = 9, 
					 ERROR_CORRECTION = 3, 
					 HEIGHT = 1, 
					 MARGIN = 5, 
					 MAX_SIZE = 12, 
					 MIN_SIZE = 11, 
					 PDF417_COMPACTION = 7, 
					 PDF417_DIMENSIONS = 8, 
					 PURE_BARCODE = 2, 
					 WIDTH = 0);

implementation

end.
