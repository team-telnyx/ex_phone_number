defmodule ExPhoneNumber.NormalizationTest do
  use ExUnit.Case, async: true

  doctest ExPhoneNumber.Normalization

  import ExPhoneNumber.Normalization

  describe ".convert_alpha_chars_in_number/1" do
    test "ConvertAlphaCharactersInNumber" do
      subject = "1800-ABC-DEF"
      assert "1800-222-333" == convert_alpha_chars_in_number(subject)
    end
  end

  describe ".normalize/1" do
    test "NormaliseRemovePunctuation" do
      subject = "034-56&+#2\u00AD34"
      assert "03456234" == normalize(subject)
    end

    test "NormaliseReplaceAlphaCharacters" do
      subject = "034-I-am-HUNGRY"
      assert "034426486479" == normalize(subject)
    end

    test "NormaliseOtherDigits" do
      subject = "\uFF125\u0665"
      assert "255" == normalize(subject)

      subject = "\u06F52\u06F0"
      assert "520" == normalize(subject)
    end
  end

  describe ".normalize_digits_only/1" do
    test "NormaliseStripAlphaCharacters" do
      subject = "034-56&+a#234"
      assert "03456234" == normalize_digits_only(subject)
    end
  end

  describe ".normalize_diallable_chars_only/1" do
    test "NormaliseStripNonDiallableCharacters" do
      subject = "03*4-56&+1a#234"
      assert "03*456+1#234" == normalize_diallable_chars_only(subject)
    end
  end
end
