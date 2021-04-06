defmodule ExPhoneNumber.Constants.Patterns do
  alias ExPhoneNumber.Constants.Values

  @single_international_prefix "[\d]+(?:[~\u2053\u223C\uFF5E][\d]+)?"
  @single_international_prefix_regex Regex.compile(@single_international_prefix)
  def single_international_prefix() do
    @single_international_prefix_regex
  end

  @unique_international_prefix "[\d]+(?:[~\u2053\u223C\uFF5E][\d]+)?"
  @unique_international_prefix_regex Regex.compile(@unique_international_prefix)
  def unique_international_prefix() do
    @unique_international_prefix_regex
  end

  def valid_punctuation() do
    "-x\u2010-\u2015\u2212\u30FC\uFF0D-\uFF0F \u00A0\u00AD\u200B\u2060\u3000" <>
      "()\uFF08\uFF09\uFF3B\uFF3D.\\[\\]/~\u2053\u223C\uFF5E"
  end

  def valid_digits(), do: "0-9\uFF10-\uFF19\u0660-\u0669\u06F0-\u06F9"

  def valid_alpha(), do: "A-Za-z"

  def plus_chars(), do: "+\uFF0B"

  def plus_chars_pattern(), do: ~r/[#{plus_chars()}]+/u

  def leading_plus_chars_pattern(), do: ~r/^[#{plus_chars()}]+/u

  def separator_pattern(), do: ~r/[#{valid_punctuation()}]+/u

  def capturing_digit_pattern(), do: ~r/([#{valid_digits()}])/u

  def valid_start_char_pattern(), do: ~r/[#{plus_chars()}#{valid_digits()}]/u

  def second_number_start_pattern(), do: ~r/[\\\/] *x/u

  def unwanted_end_char_pattern(), do: ~r/[^#{valid_digits()}#{valid_alpha()}#]+$/u

  def valid_alpha_phone_pattern(), do: ~r/(?:.*?[A-Za-z]){3}.*/u

  def min_length_phone_number_pattern(),
    do: "[" <> valid_digits() <> "]{" <> Integer.to_string(Values.min_length_for_nsn()) <> "}"

  def valid_phone_number() do
    "[" <>
      plus_chars() <>
      "]*(?:[" <>
      valid_punctuation() <>
      Values.star_sign() <>
      "]*[" <>
      valid_digits() <>
      "]){3,}[" <>
      valid_punctuation() <>
      Values.star_sign() <>
      valid_alpha() <>
      valid_digits() <> "]*"
  end

  def default_extn_prefix(), do: " ext. "

  def extn_digits(max_length) when is_binary(max_length) do
    "([#{valid_digits()}]{1,#{max_length}})"
  end

  @doc """
  i18n.phonenumbers.PhoneNumberUtil.createExtnPattern_ =
  """
  def create_extn_pattern() do
    ext_limit_after_explicit_label = "20"
    ext_limit_after_likely_label = "15"
    ext_limit_after_ambiguous_char = "9"
    ext_limit_when_not_sure = "6"

    possible_separators_between_number_and_ext_label = "[ \u00A0\\t,]*"
    possible_chars_after_ext_label = "[:\\.\uFF0E]?[ \u00A0\\t,-]*"
    optional_extn_suffix = "#?"

    explicit_ext_labels = "(?:e?xt(?:ensi(?:o\u0301?|\u00F3))?n?|\uFF45?\uFF58\uFF54\uFF4E?|\u0434\u043E\u0431|anexo)"

    ambiguous_ext_labels = "(?:[x\uFF58#\uFF03~\uFF5E]|int|\uFF49\uFF4E\uFF54)"

    ambiguous_separator = "[- ]+"
    possible_separators_number_ext_label_no_comma = "[ \u00A0\\t]*"
    auto_dialling_and_ext_labels_found = "(?:,{2}|;)"

    rfc_extn = Values.rfc3966_extn_prefix() <> extn_digits(ext_limit_after_explicit_label)

    explicit_extn =
      possible_separators_between_number_and_ext_label <>
        explicit_ext_labels <>
        possible_chars_after_ext_label <>
        extn_digits(ext_limit_after_explicit_label) <>
        optional_extn_suffix

    ambiguous_extn =
      possible_separators_between_number_and_ext_label <>
        ambiguous_ext_labels <>
        possible_chars_after_ext_label <>
        extn_digits(ext_limit_after_ambiguous_char) <>
        optional_extn_suffix

    american_style_extn_with_suffix =
      ambiguous_separator <>
        extn_digits(ext_limit_when_not_sure) <> "#"

    auto_dialling_extn =
      possible_separators_number_ext_label_no_comma <>
        auto_dialling_and_ext_labels_found <>
        possible_chars_after_ext_label <>
        extn_digits(ext_limit_after_likely_label) <>
        optional_extn_suffix

    only_commas_extn =
      possible_separators_number_ext_label_no_comma <>
        "(?:,)+" <>
        possible_chars_after_ext_label <>
        extn_digits(ext_limit_after_ambiguous_char) <>
        optional_extn_suffix

    rfc_extn <>
      "|" <>
      explicit_extn <>
      "|" <>
      ambiguous_extn <>
      "|" <>
      american_style_extn_with_suffix <>
      "|" <>
      auto_dialling_extn <>
      "|" <>
      only_commas_extn
  end

  def extn_pattern(), do: ~r/(?:#{create_extn_pattern()})$/iu

  def valid_phone_number_pattern() do
    ~r/^#{min_length_phone_number_pattern()}$|^#{valid_phone_number()}(?:#{create_extn_pattern()})?$/iu
  end

  def non_digits_pattern(), do: ~r/\D+/u

  def first_group_pattern(), do: ~r/(\\g{\d})/u

  def np_pattern(), do: ~r/\$NP/u

  def fg_pattern(), do: ~r/\$FG/u

  def cc_pattern(), do: ~r/\$CC/u

  def first_group_only_prefix_pattern(), do: ~r/^\(?\$1\)?$/u
end
