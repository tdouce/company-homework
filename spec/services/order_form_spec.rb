require "rails_helper"

RSpec.describe OrderForm do
  let(:child_params) do
    {
     some: "child_params"
    }
  end
  let(:order_params) do
    {
      some: "order_params",
    }
  end
  let(:order) { instance_double(Order) }

  subject do
    described_class.new(
      child_params: child_params,
      order_params: order_params,
      gift_params: gift_params
    )
  end

  describe "#process_order" do
    context "when the order is not a gift" do
      let(:gift_params) { {} }
      let(:standard_order_klass) { class_double(StandardOrder) }
      let(:standard_order) { instance_double(StandardOrder) }
      let(:order) { instance_double(Order) }

      it "creates a child and an order" do
        expect(standard_order_klass).to receive(:new).with(
          child_params: child_params,
          order_params: order_params
        ).and_return(standard_order)

        expect(standard_order).to receive(:process_order).and_return(order)

        response = subject.process_order(standard_order_klass: standard_order_klass)

        expect(response.order).to eq(order)
        expect(response.gift?).to eq(false)
      end
    end

    context "when the order is a gift" do
      let(:gift_params) do
        {
          message: "Happy Birthday",
          gifter_name: "Grandma Jones"
        }
      end
      let(:gift_order_klass) { class_double(GiftOrder) }
      let(:gift_order) { instance_double(GiftOrder) }

      it "creates a gift order" do
        expect(gift_order_klass).to receive(:new).with(
          child_params: child_params,
          order_params: order_params,
          gift_params: gift_params
        ).and_return(gift_order)

        expect(gift_order).to receive(:process_order).and_return(order)
        
        response = subject.process_order(gift_order_klass: gift_order_klass)

        expect(response.order).to eq(order)
        expect(response.gift?).to eq(true)
      end
    end
  end
end