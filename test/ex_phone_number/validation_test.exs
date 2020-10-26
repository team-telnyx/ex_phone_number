defmodule ExPhoneNumber.ValidationTest do
  use ExUnit.Case, async: true

  doctest ExPhoneNumber.Validation

  import ExPhoneNumber.Validation

  alias ExPhoneNumber.{PhoneNumberFixture, RegionCodeFixture}
  alias ExPhoneNumber.Constants.PhoneNumberTypes
  alias ExPhoneNumber.Constants.ValidationResults

  describe ".is_possible_number?/1" do
    test "IsPossibleNumber" do
      assert is_possible_number?(PhoneNumberFixture.us_number())
      assert is_possible_number?(PhoneNumberFixture.us_local_number())
      assert is_possible_number?(PhoneNumberFixture.gb_number())
      assert is_possible_number?(PhoneNumberFixture.international_toll_free())
    end

    test "IsNotPossibleNumber" do
      refute is_possible_number?(PhoneNumberFixture.us_long_number())
      refute is_possible_number?(PhoneNumberFixture.international_toll_free_too_long())
      refute is_possible_number?(PhoneNumberFixture.nanpa_short_number())
      refute is_possible_number?(PhoneNumberFixture.gb_short_number())
    end
  end

  describe ".is_possible_number_with_reason?/1" do
    test "IsPossibleNumberWithReason" do
      assert ValidationResults.is_possible() ==
               is_possible_number_with_reason?(PhoneNumberFixture.us_number())

      assert ValidationResults.is_possible() ==
               is_possible_number_with_reason?(PhoneNumberFixture.us_local_number())

      assert ValidationResults.too_long() ==
               is_possible_number_with_reason?(PhoneNumberFixture.us_long_number())

      assert ValidationResults.invalid_country_code() ==
               is_possible_number_with_reason?(PhoneNumberFixture.unknown_country_code3())

      assert ValidationResults.too_short() ==
               is_possible_number_with_reason?(PhoneNumberFixture.nanpa_short_number())

      assert ValidationResults.is_possible() ==
               is_possible_number_with_reason?(PhoneNumberFixture.sg_number2())

      assert ValidationResults.too_long() ==
               is_possible_number_with_reason?(PhoneNumberFixture.international_toll_free_too_long())
    end
  end

  describe ".is_viable_phone_number?/1" do
    test "should contain at least 2 chars" do
      refute is_viable_phone_number?("1")
    end

    test "should allow only one or two digits before strange non-possible puntuaction ascii" do
      refute is_viable_phone_number?("1+1+1")
      refute is_viable_phone_number?("80+0")
    end

    test "should allow two or more digits" do
      assert is_viable_phone_number?("00")
      assert is_viable_phone_number?("111")
    end

    test "should allow alpha numbers" do
      assert is_viable_phone_number?("0800-4-pizza")
      assert is_viable_phone_number?("0800-4-PIZZA")
    end

    test "should contain at least three digits before any alpha char" do
      refute is_viable_phone_number?("08-PIZZA")
      refute is_viable_phone_number?("8-PIZZA")
      refute is_viable_phone_number?("12. March")
    end

    test "should allow only one or two digits before strange non-possible puntuaction unicode" do
      assert is_viable_phone_number?("1\u300034")
      refute is_viable_phone_number?("1\u30003+4")
    end

    test "should allow unicode variants of starting chars" do
      assert is_viable_phone_number?("\uFF081\uFF09\u30003456789")
    end

    test "should allow leading plus sign" do
      assert is_viable_phone_number?("+1\uFF09\u30003456789")
    end
  end

  describe ".is_valid_number/1" do
    test "Valid numbers" do
      assert is_valid_number?(PhoneNumberFixture.us_number())

      assert is_valid_number?(PhoneNumberFixture.it_number())

      assert is_valid_number?(PhoneNumberFixture.gb_mobile())

      assert is_valid_number?(PhoneNumberFixture.international_toll_free())

      assert is_valid_number?(PhoneNumberFixture.universal_premium_rate())

      assert is_valid_number?(PhoneNumberFixture.nz_number2())
    end

    test "Invalid numbers" do
      refute is_valid_number?(PhoneNumberFixture.us_local_number())

      refute is_valid_number?(PhoneNumberFixture.it_invalid())

      refute is_valid_number?(PhoneNumberFixture.gb_invalid())

      refute is_valid_number?(PhoneNumberFixture.de_invalid())

      refute is_valid_number?(PhoneNumberFixture.nz_invalid())

      refute is_valid_number?(PhoneNumberFixture.international_toll_free_too_long())
    end

    test "Invalid country code" do
      refute is_valid_number?(PhoneNumberFixture.unknown_country_code())

      refute is_valid_number?(PhoneNumberFixture.unknown_country_code2())
    end

    test "BS number" do
      assert is_valid_number?(PhoneNumberFixture.bs_number())

      refute is_valid_number?(PhoneNumberFixture.bs_number_invalid())
    end

    test "DE invalid number returns false #2" do
      {result, phone_number} = ExPhoneNumber.parse("+494915778961257", "DE")

      assert :ok == result
      refute is_valid_number?(phone_number)
    end

    test "RE number" do
      assert is_valid_number?(PhoneNumberFixture.re_number())

      refute is_valid_number?(PhoneNumberFixture.re_number_invalid())
    end

    test "YT number" do
      assert is_valid_number?(PhoneNumberFixture.yt_number())
    end
  end

  describe ".is_valid_number_for_region?/2" do
    test "BS number" do
      assert is_valid_number_for_region?(PhoneNumberFixture.bs_number(), RegionCodeFixture.bs())

      refute is_valid_number_for_region?(PhoneNumberFixture.bs_number(), RegionCodeFixture.us())
    end

    test "RE number" do
      assert is_valid_number_for_region?(PhoneNumberFixture.re_number(), RegionCodeFixture.re())

      refute is_valid_number_for_region?(PhoneNumberFixture.re_number(), RegionCodeFixture.yt())

      refute is_valid_number_for_region?(PhoneNumberFixture.re_number_invalid(), RegionCodeFixture.re())

      refute is_valid_number_for_region?(PhoneNumberFixture.re_number_invalid(), RegionCodeFixture.yt())
    end

    test "YT number" do
      assert is_valid_number_for_region?(PhoneNumberFixture.yt_number(), RegionCodeFixture.yt())

      refute is_valid_number_for_region?(PhoneNumberFixture.yt_number(), RegionCodeFixture.re())
    end

    test "Multi Country number" do
      assert is_valid_number_for_region?(
               PhoneNumberFixture.re_yt_number(),
               RegionCodeFixture.re()
             )

      assert is_valid_number_for_region?(
               PhoneNumberFixture.re_yt_number(),
               RegionCodeFixture.yt()
             )
    end

    test "International Toll Free" do
      assert is_valid_number_for_region?(
               PhoneNumberFixture.international_toll_free(),
               RegionCodeFixture.un001()
             )

      refute is_valid_number_for_region?(
               PhoneNumberFixture.international_toll_free(),
               RegionCodeFixture.us()
             )

      refute is_valid_number_for_region?(
               PhoneNumberFixture.international_toll_free(),
               RegionCodeFixture.zz()
             )
    end
  end

  describe ".is_number_geographical?/1" do
    test "IsNumberGeographical" do
      refute is_number_geographical?(PhoneNumberFixture.bs_mobile())
      assert is_number_geographical?(PhoneNumberFixture.au_number())
      refute is_number_geographical?(PhoneNumberFixture.international_toll_free())
      assert is_number_geographical?(PhoneNumberFixture.ar_mobile())
      assert is_number_geographical?(PhoneNumberFixture.mx_mobile1())
      assert is_number_geographical?(PhoneNumberFixture.mx_mobile2())
    end
  end

  describe ".get_number_type/1" do
    test "Premium Rate" do
      assert get_number_type(PhoneNumberFixture.us_premium()) == PhoneNumberTypes.premium_rate()

      assert get_number_type(PhoneNumberFixture.it_premium()) == PhoneNumberTypes.premium_rate()

      assert get_number_type(PhoneNumberFixture.gb_premium()) == PhoneNumberTypes.premium_rate()

      assert get_number_type(PhoneNumberFixture.de_premium()) == PhoneNumberTypes.premium_rate()

      assert get_number_type(PhoneNumberFixture.de_premium2()) ==
               PhoneNumberTypes.premium_rate()

      assert get_number_type(PhoneNumberFixture.universal_premium_rate()) ==
               PhoneNumberTypes.premium_rate()
    end

    test "Toll Free" do
      assert get_number_type(PhoneNumberFixture.us_tollfree2()) == PhoneNumberTypes.toll_free()

      assert get_number_type(PhoneNumberFixture.it_toll_free()) == PhoneNumberTypes.toll_free()

      assert get_number_type(PhoneNumberFixture.gb_toll_free()) == PhoneNumberTypes.toll_free()

      assert get_number_type(PhoneNumberFixture.de_toll_free()) == PhoneNumberTypes.toll_free()

      assert get_number_type(PhoneNumberFixture.international_toll_free()) ==
               PhoneNumberTypes.toll_free()
    end

    test "Mobile" do
      assert get_number_type(PhoneNumberFixture.bs_mobile()) == PhoneNumberTypes.mobile()

      assert get_number_type(PhoneNumberFixture.gb_mobile()) == PhoneNumberTypes.mobile()

      assert get_number_type(PhoneNumberFixture.it_mobile()) == PhoneNumberTypes.mobile()

      assert get_number_type(PhoneNumberFixture.ar_mobile()) == PhoneNumberTypes.mobile()

      assert get_number_type(PhoneNumberFixture.de_mobile()) == PhoneNumberTypes.mobile()
    end

    test "Fixed Line" do
      assert get_number_type(PhoneNumberFixture.bs_number()) == PhoneNumberTypes.fixed_line()

      assert get_number_type(PhoneNumberFixture.it_number()) == PhoneNumberTypes.fixed_line()

      assert get_number_type(PhoneNumberFixture.gb_number()) == PhoneNumberTypes.fixed_line()

      assert get_number_type(PhoneNumberFixture.de_number()) == PhoneNumberTypes.fixed_line()
    end

    test "Fixed Line Or Mobile" do
      assert get_number_type(PhoneNumberFixture.us_number()) ==
               PhoneNumberTypes.fixed_line_or_mobile()

      assert get_number_type(PhoneNumberFixture.ar_number2()) ==
               PhoneNumberTypes.fixed_line_or_mobile()
    end

    test "Shared Cost" do
      assert get_number_type(PhoneNumberFixture.gb_shared_cost()) ==
               PhoneNumberTypes.shared_cost()
    end

    test "VOIP" do
      assert get_number_type(PhoneNumberFixture.gb_voip()) == PhoneNumberTypes.voip()
    end

    test "Personal Number" do
      assert get_number_type(PhoneNumberFixture.gb_personal_number()) ==
               PhoneNumberTypes.personal_number()
    end

    test "UNKNOWN" do
      assert get_number_type(PhoneNumberFixture.us_local_number()) == PhoneNumberTypes.unknown()
    end
  end

  describe ".validate_length" do
    test "length less or equal to Constants.Value.max_input_string_length returns {:ok, number}" do
      subject = "1234567890"
      assert {:ok, _} = validate_length(subject)
    end

    test "length larger than Constants.Value.max_input_string_length returns {:error, message}" do
      subject =
        "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890x"

      assert {:error, _} = validate_length(subject)
    end
  end
end
