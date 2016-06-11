require 'spec_helper_without_rails'

describe Condition do
  it "can be new" do
    expect { Condition::NEW }.not_to raise_exception
  end

  it "can be used" do
    expect { Condition::USED }.not_to raise_exception
  end

  it "can be collectible" do
    expect { Condition::COLLECTIBLE }.not_to raise_exception
  end

  context "when validating condition" do
    context "for recognized input" do
      it "creates corresponding condition" do
        expect(Condition.from("new")).to eq(Condition::NEW)
      end

      it "is case insensitive" do
        expect(Condition.from("NeW")).to eq(Condition::NEW)
      end

      it "takes the beginning into account" do
        expect(Condition.from("Used like New")).to eq(Condition::USED)
      end
    end

    context "for not recognized input" do
      it "raises exception" do
        expect { Condition.from("?") }.to raise_exception(ArgumentError)
      end
    end
  end
end