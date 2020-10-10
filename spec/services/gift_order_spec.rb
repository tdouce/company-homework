require "rails_helper"

RSpec.describe GiftOrder do
  let!(:product) do
    Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12
    )
  end
  let!(:child) do
    Child.create(
      full_name: "Kim Jones",
      birthdate: Date.parse("2020-01-01"),
      parent_name: "Pat Jones"
    )
  end
  let(:child_full_name) { child.full_name }
  let(:parent_name) { child.parent_name }
  let(:birthdate) { Date.parse("2020-01-01") }
  let(:child_params) do
    {
      full_name: child_full_name,
      parent_name: parent_name,
      birthdate: birthdate
    }
  end
  let(:zipcode) { "31794" }
  let(:address) { "123 Any St." }
  let(:order_params) do
    {
      product_id: product.id,
      paid: false
    }
  end
  let(:gift_params) do
    {
      message: "Happy Birthday",
      gifter_name: "Grandma Jones"
    }
  end

  subject do
    described_class.new(
      child_params: child_params,
      order_params: order_params,
      gift_params: gift_params
    )
  end

  context "success" do
    context "when child is found" do
      context "when a previous order is found" do
        let!(:existing_order) do
          Order.create(
            user_facing_id: "064b2adb",
            product_id: product.id,
            child_id: child.id,
            shipping_name: "Some Parent Name",
            address: "123 Other St",
            zipcode: "83701",
            paid: true
          )
        end

        it "creates an order using the address and zipcode from a previous order" do
          order = subject.process_order

          expect(order).to be_valid

          expect(order.message).to eq(gift_params[:message])
          expect(order.shipping_name).to eq(gift_params[:gifter_name])
          expect(order.address).to eq(existing_order.address)
          expect(order.zipcode).to eq(existing_order.zipcode)
          expect(order.product).to eq(product)
          expect(order.user_facing_id).to be_present
          expect(order.child.full_name).to eq(child_full_name)
          expect(order.child.birthdate).to eq(birthdate)
          expect(order.child.parent_name).to eq(parent_name)
        end
      end
    end
  end

  context "failure" do
    context "when child is not found" do
      context "when child's full_name does not match an existing child record" do
        let(:child_full_name) { "unknown_child_full_name" }

        it "returns a invalid order" do
          order = subject.process_order

          expect(order).to be_invalid
          expect(order.errors[:child].size).to eq(1)
        end
      end

      context "when child is found by full_name but not by parent_name" do
        let(:parent_name) { "non_existing_parent_name" }

        it "returns a invalid order" do
          order = subject.process_order

          expect(order).to be_invalid
          expect(order.errors[:child].size).to eq(1)
        end
      end

      context "when child is found by full_name, by parent_name, but not by birthdate" do
        let(:birthdate) { Date.parse("2010-01-01") }

        it "returns a invalid order" do
          order = subject.process_order

          expect(order).to be_invalid
          expect(order.errors[:child].size).to eq(1)
        end
      end
    end
  end
end