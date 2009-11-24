# -*- coding: utf-8 -*-
require 'test/unit'
require File.dirname(File.expand_path(__FILE__)) + '/../lib/ods'

class OdsTest < Test::Unit::TestCase
  BASE_DIR = File.dirname(File.expand_path(__FILE__))
  def setup
    @ods = Ods.new(BASE_DIR + '/cook.ods')
    @file_path = BASE_DIR + '/modified.ods'
  end

  def teardown
    File.unlink(@file_path) if File.exists?(@file_path)
  end

  def test_sheet_count
    assert_equal 3, @ods.sheets.length
  end

  def test_sheet_name
    assert_equal 'さつま揚げとキャベツのお味噌汁', @ods.sheets[0].name
  end

  def test_sheet_name_modify
    modified_name = 'hogehoge'
    offset = 2

    assert_not_equal modified_name, @ods.sheets[offset].name
    @ods.sheets[offset].name = modified_name
    @ods.save(@file_path)
    modified_ods = Ods.new(@file_path)
    assert_equal modified_name, modified_ods.sheets[offset].name
  end

  def test_get_column
    sheet = @ods.sheets[0]
    assert_equal 'だし汁', sheet[2, :A]
    assert_equal '適量', sheet[6, :B]
  end

  def test_modify_column
    sheet_offset = 0
    row = 2
    col = :B
    sheet = @ods.sheets[sheet_offset]
    modified_text = '酢味噌'
    assert_not_equal modified_text, sheet[row, col]
    sheet[row, col] = modified_text
    @ods.save(@file_path)
    modified_ods = Ods.new(@file_path)
    assert_equal modified_text, modified_ods.sheets[sheet_offset][row, col]
  end

  def test_access_not_existed_sheet
    ods_length = @ods.sheets.length
    new_sheet = @ods.create_sheet
    assert_equal "Sheet#{ods_length+1}", new_sheet.name
    assert_equal '', new_sheet[1, :A]
    assert_nothing_raised { new_sheet[100, :CC] = '' }
  end
end
