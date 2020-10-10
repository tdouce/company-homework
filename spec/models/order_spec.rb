require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'class methods' do
    describe '.generate_user_facing_id' do
      let(:secure_random_klass) { class_double(SecureRandom) }

      it 'generates a a unique id' do
        expect(secure_random_klass).to receive(:uuid).and_return([1,2,3,4,5,6,7,8,9])

        response = described_class.generate_user_facing_id(
          secure_random_klass: secure_random_klass
        )

        expect(response).to eq([1,2,3,4,5,6,7,8])
      end
    end
  end

  describe "#validations" do
    it "requires shipping_name" do
      order = Order.new(
        product: Product.new,
        shipping_name: nil,
        address: "123 Some Road",
        zipcode: "90210",
        user_facing_id: "890890908980980"
      )

      expect(order.valid?).to eq(false)
      expect(order.errors[:shipping_name].size).to eq(1)
    end

    describe '#message' do
      it "can have a message" do
        child = Child.create(
          full_name: "some_child full name",
          birthdate: "2020-01-01",
          parent_name: "some_parent_name"
        )

        order = Order.new(
          child: child,
          product: Product.new,
          shipping_name: "Some shipping name",
          address: "123 Some Road",
          message: "some message",
          zipcode: "90210",
          user_facing_id: "890890908980980"
        )

        expect(order.valid?).to eq(true)
        expect(order.message).to eq("some message")
      end

      it "can not be longer than 1000 characters" do
        child = Child.create(
          full_name: "some_child full name",
          birthdate: "2020-01-01",
          parent_name: "some_parent_name"
        )

        order = Order.new(
          child: child,
          product: Product.new,
          shipping_name: "Some shipping name",
          address: "123 Some Road",
          zipcode: "90210",
          user_facing_id: "890890908980980"
        )

        valid_message = 1.upto(1000).map {"a"}.join
        order.message = valid_message
        expect(order.valid?).to eq(true)
        expect(order.message).to eq(valid_message)

        invalid_message = order.message = valid_message + "a"
        order.message = invalid_message
        expect(order.valid?).to eq(false)
        expect(order.errors[:message].size).to eq(1)
      end
    end
  end
end
