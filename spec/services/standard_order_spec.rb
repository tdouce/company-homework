require 'rails_helper'

RSpec.describe StandardOrder do
  let!(:product) do
    Product.create!(
      name: "product1",
      description: "description2",
      price_cents: 1000,
      age_low_weeks: 0,
      age_high_weeks: 12
    )
  end

  subject do
    described_class.new(
      child_params: child_params,
      order_params: order_params
    )
  end

  context "success" do
    let(:child_params) do
      {
        full_name: "Kim Jones",
        parent_name: "Pat Jones",
        birthdate: Date.parse("2020-01-01")
      }
    end
    let(:order_params) do
      {
        product_id: product.id,
        zipcode: "31794",
        address: "123 Any St.",
        paid: false
      }
    end

    context "when child does not exist" do
      it "creates a child and an order" do
        order = subject.process_order

        expect(order).to be_valid
        expect(order.shipping_name).to eq("Pat Jones")
        expect(order.address).to eq("123 Any St.")
        expect(order.zipcode).to eq("31794")
        expect(order.product).to eq(product)
        expect(order.child.full_name).to eq("Kim Jones")
        expect(order.child.birthdate.to_s).to eq("2020-01-01")
        expect(order.child.parent_name).to eq("Pat Jones")
      end
    end

    context "when child does exist" do
      let!(:child) { Child.create!(child_params) }

      it "creates an order for the child" do
        order = subject.process_order

        expect(order).to be_valid
        expect(order.shipping_name).to eq("Pat Jones")
        expect(order.address).to eq("123 Any St.")
        expect(order.zipcode).to eq("31794")
        expect(order.product).to eq(product)
        expect(order.child).to eq(child)
        expect(order.child.full_name).to eq("Kim Jones")
        expect(order.child.birthdate.to_s).to eq("2020-01-01")
        expect(order.child.parent_name).to eq("Pat Jones")

        expect(Child.count).to eq(1)
      end
    end
  end
end