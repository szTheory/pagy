
# frozen_string_literal: true

require_relative '../test_helper'

describe Pagy::Backend do

  let(:controller) { MockController.new }

  describe "#pagy" do

    before do
      @collection = MockCollection.new
    end

    it 'paginates with defaults' do
      pagy, records = controller.send(:pagy, @collection)
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal Pagy::VARS[:items]
      _(pagy.page).must_equal controller.params[:page]
      _(records.count).must_equal Pagy::VARS[:items]
      _(records).must_equal [41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60]
    end

    it 'paginates with vars' do
      pagy, records = controller.send(:pagy, @collection, page: 2, items: 10, link_extra: 'X')
      _(pagy).must_be_instance_of Pagy
      _(pagy.count).must_equal 1000
      _(pagy.items).must_equal 10
      _(pagy.page).must_equal 2
      _(pagy.vars[:link_extra]).must_equal 'X'
      _(records.count).must_equal 10
      _(records).must_equal [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end

  end

  describe "#pagy_get_vars" do

    before do
      @collection = MockCollection.new
    end

    it 'gets defaults' do
      vars   = {}
      merged = controller.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 3
    end

    it 'gets vars' do
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = controller.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :items
      _(merged.keys).must_include :link_extra
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:items]).must_equal 10
      _(merged[:link_extra]).must_equal 'X'
    end

    it 'works with grouped collections' do
      @collection = MockCollection::Grouped.new((1..1000).to_a)
      vars   = {page: 2, items: 10, link_extra: 'X'}
      merged = controller.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged.keys).must_include :page
      _(merged.keys).must_include :items
      _(merged.keys).must_include :link_extra
      _(merged[:count]).must_equal 1000
      _(merged[:page]).must_equal 2
      _(merged[:items]).must_equal 10
      _(merged[:link_extra]).must_equal 'X'
    end

    it 'overrides count and page' do
      vars   = {count: 10, page: 32}
      merged = controller.send :pagy_get_vars, @collection, vars
      _(merged.keys).must_include :count
      _(merged[:count]).must_equal 10
      _(merged.keys).must_include :page
      _(merged[:page]).must_equal 32
    end

  end

  describe "#pagy_get_items" do

    it 'gets items' do
      collection = MockCollection.new
      pagy       = Pagy.new count: 1000
      items      = controller.send :pagy_get_items, collection, pagy
      _(items).must_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    end

  end

end
