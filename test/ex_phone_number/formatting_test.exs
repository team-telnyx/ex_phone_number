defmodule ExPhoneNumber.FormattingTest do
  use ExUnit.Case, async: true

  doctest ExPhoneNumber.Formatting

  import ExPhoneNumber.Formatting

  alias ExPhoneNumber.PhoneNumberFixture
  alias ExPhoneNumber.Constants.PhoneNumberFormats

  describe ".format/2" do
    test "FormatUSNumber" do
      assert "650 253 0000" ==
               format(PhoneNumberFixture.us_number(), PhoneNumberFormats.national())

      assert "+1 650 253 0000" ==
               format(PhoneNumberFixture.us_number(), PhoneNumberFormats.international())

      assert "800 253 0000" ==
               format(PhoneNumberFixture.us_tollfree(), PhoneNumberFormats.national())

      assert "+1 800 253 0000" ==
               format(PhoneNumberFixture.us_tollfree(), PhoneNumberFormats.international())

      assert "900 253 0000" ==
               format(PhoneNumberFixture.us_premium(), PhoneNumberFormats.national())

      assert "+1 900 253 0000" ==
               format(PhoneNumberFixture.us_premium(), PhoneNumberFormats.international())

      assert "tel:+1-900-253-0000" ==
               format(PhoneNumberFixture.us_premium(), PhoneNumberFormats.rfc3966())

      assert "000-000-0000" ==
               format(
                 PhoneNumberFixture.us_spoof_with_raw_input(),
                 PhoneNumberFormats.national()
               )

      assert "0" == format(PhoneNumberFixture.us_spoof(), PhoneNumberFormats.national())
    end

    test "FormatBSNumber" do
      assert "242 365 1234" ==
               format(PhoneNumberFixture.bs_number(), PhoneNumberFormats.national())

      assert "+1 242 365 1234" ==
               format(PhoneNumberFixture.bs_number(), PhoneNumberFormats.international())
    end

    test "FormatGBNumber" do
      assert "(020) 7031 3000" ==
               format(PhoneNumberFixture.gb_number(), PhoneNumberFormats.national())

      assert "+44 20 7031 3000" ==
               format(PhoneNumberFixture.gb_number(), PhoneNumberFormats.international())

      assert "(07912) 345 678" ==
               format(PhoneNumberFixture.gb_mobile(), PhoneNumberFormats.national())

      assert "+44 7912 345 678" ==
               format(PhoneNumberFixture.gb_mobile(), PhoneNumberFormats.international())
    end

    test "FormatDENumber" do
      assert "030/1234" ==
               format(PhoneNumberFixture.de_number2(), PhoneNumberFormats.national())

      assert "+49 30/1234" ==
               format(PhoneNumberFixture.de_number2(), PhoneNumberFormats.international())

      assert "tel:+49-30-1234" ==
               format(PhoneNumberFixture.de_number2(), PhoneNumberFormats.rfc3966())

      assert "0291 123" ==
               format(PhoneNumberFixture.de_number3(), PhoneNumberFormats.national())

      assert "+49 291 123" ==
               format(PhoneNumberFixture.de_number3(), PhoneNumberFormats.international())

      assert "0291 12345678" ==
               format(PhoneNumberFixture.de_number4(), PhoneNumberFormats.national())

      assert "+49 291 12345678" ==
               format(PhoneNumberFixture.de_number4(), PhoneNumberFormats.international())

      assert "09123 12345" ==
               format(PhoneNumberFixture.de_number5(), PhoneNumberFormats.national())

      assert "+49 9123 12345" ==
               format(PhoneNumberFixture.de_number5(), PhoneNumberFormats.international())

      assert "08021 2345" ==
               format(PhoneNumberFixture.de_number6(), PhoneNumberFormats.national())

      assert "+49 8021 2345" ==
               format(PhoneNumberFixture.de_number6(), PhoneNumberFormats.international())

      assert "1234" ==
               format(PhoneNumberFixture.de_short_number(), PhoneNumberFormats.national())

      assert "+49 1234" ==
               format(PhoneNumberFixture.de_short_number(), PhoneNumberFormats.international())

      assert "04134 1234" ==
               format(PhoneNumberFixture.de_number7(), PhoneNumberFormats.national())
    end

    test "FormatITNumber" do
      assert "02 3661 8300" ==
               format(PhoneNumberFixture.it_number(), PhoneNumberFormats.national())

      assert "+39 02 3661 8300" ==
               format(PhoneNumberFixture.it_number(), PhoneNumberFormats.international())

      assert "+390236618300" ==
               format(PhoneNumberFixture.it_number(), PhoneNumberFormats.e164())

      assert "345 678 901" ==
               format(PhoneNumberFixture.it_mobile(), PhoneNumberFormats.national())

      assert "+39 345 678 901" ==
               format(PhoneNumberFixture.it_mobile(), PhoneNumberFormats.international())

      assert "+39345678901" == format(PhoneNumberFixture.it_mobile(), PhoneNumberFormats.e164())
    end

    test "FormatAUNumber" do
      assert "02 3661 8300" ==
               format(PhoneNumberFixture.au_number(), PhoneNumberFormats.national())

      assert "+61 2 3661 8300" ==
               format(PhoneNumberFixture.au_number(), PhoneNumberFormats.international())

      assert "+61236618300" == format(PhoneNumberFixture.au_number(), PhoneNumberFormats.e164())

      assert "1800 123 456" ==
               format(PhoneNumberFixture.au_number2(), PhoneNumberFormats.national())

      assert "+61 1800 123 456" ==
               format(PhoneNumberFixture.au_number2(), PhoneNumberFormats.international())

      assert "+611800123456" ==
               format(PhoneNumberFixture.au_number2(), PhoneNumberFormats.e164())
    end

    test "FormatARNumber" do
      assert "011 8765-4321" ==
               format(PhoneNumberFixture.ar_number(), PhoneNumberFormats.national())

      assert "+54 11 8765-4321" ==
               format(PhoneNumberFixture.ar_number(), PhoneNumberFormats.international())

      assert "+541187654321" ==
               format(PhoneNumberFixture.ar_number(), PhoneNumberFormats.e164())

      assert "011 15 8765-4321" ==
               format(PhoneNumberFixture.ar_mobile(), PhoneNumberFormats.national())

      assert "+54 9 11 8765 4321" ==
               format(PhoneNumberFixture.ar_mobile(), PhoneNumberFormats.international())

      assert "+5491187654321" ==
               format(PhoneNumberFixture.ar_mobile(), PhoneNumberFormats.e164())
    end

    test "FormatMXNumber" do
      assert "045 234 567 8900" ==
               format(PhoneNumberFixture.mx_mobile1(), PhoneNumberFormats.national())

      assert "+52 1 234 567 8900" ==
               format(PhoneNumberFixture.mx_mobile1(), PhoneNumberFormats.international())

      assert "+5212345678900" ==
               format(PhoneNumberFixture.mx_mobile1(), PhoneNumberFormats.e164())

      assert "045 55 1234 5678" ==
               format(PhoneNumberFixture.mx_mobile2(), PhoneNumberFormats.national())

      assert "+52 1 55 1234 5678" ==
               format(PhoneNumberFixture.mx_mobile2(), PhoneNumberFormats.international())

      assert "+5215512345678" ==
               format(PhoneNumberFixture.mx_mobile2(), PhoneNumberFormats.e164())

      assert "01 33 1234 5678" ==
               format(PhoneNumberFixture.mx_number1(), PhoneNumberFormats.national())

      assert "+52 33 1234 5678" ==
               format(PhoneNumberFixture.mx_number1(), PhoneNumberFormats.international())

      assert "+523312345678" ==
               format(PhoneNumberFixture.mx_number1(), PhoneNumberFormats.e164())

      assert "01 821 123 4567" ==
               format(PhoneNumberFixture.mx_number2(), PhoneNumberFormats.national())

      assert "+52 821 123 4567" ==
               format(PhoneNumberFixture.mx_number2(), PhoneNumberFormats.international())

      assert "+528211234567" ==
               format(PhoneNumberFixture.mx_number2(), PhoneNumberFormats.e164())
    end

    test "FormatWithCarrierCode" do
      assert "02234 65-4321" ==
               format(PhoneNumberFixture.ar_mobile4(), PhoneNumberFormats.national())

      assert "+5492234654321" ==
               format(PhoneNumberFixture.ar_mobile4(), PhoneNumberFormats.e164())
    end

    test "FormatWithPreferredCarrierCode" do
      assert "01234 12-5678" == format(PhoneNumberFixture.ar_number6(), PhoneNumberFormats.national())
      assert "424 123 1234" == format(PhoneNumberFixture.us_number3(), PhoneNumberFormats.national())
    end

    test "FormatE164Number" do
      assert "+16502530000" == format(PhoneNumberFixture.us_number(), PhoneNumberFormats.e164())

      assert "+4930123456" == format(PhoneNumberFixture.de_number(), PhoneNumberFormats.e164())

      assert "+80012345678" ==
               format(PhoneNumberFixture.international_toll_free(), PhoneNumberFormats.e164())
    end

    test "FormatNumberWithExtension" do
      assert "03-331 6005 ext. 1234" ==
               format(
                 %{PhoneNumberFixture.nz_number() | extension: "1234"},
                 PhoneNumberFormats.national()
               )

      assert "tel:+64-3-331-6005;ext=1234" ==
               format(
                 %{PhoneNumberFixture.nz_number() | extension: "1234"},
                 PhoneNumberFormats.rfc3966()
               )

      assert "650 253 0000 extn. 4567" ==
               format(
                 %{PhoneNumberFixture.us_number() | extension: "4567"},
                 PhoneNumberFormats.national()
               )
    end

    test "CountryWithNoNumberDesc" do
      assert "+376 12345" == format(PhoneNumberFixture.ad_number(), PhoneNumberFormats.international())
      assert "+37612345" == format(PhoneNumberFixture.ad_number(), PhoneNumberFormats.e164())
      assert "12345" == format(PhoneNumberFixture.ad_number(), PhoneNumberFormats.national())
    end

    test "UnknownCountryCallingCode" do
      assert "+212345" == format(PhoneNumberFixture.unknown_country_code_no_raw_input(), PhoneNumberFormats.e164())
    end
  end
end
