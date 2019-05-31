RSpec.describe Yap do

  it "parse code to ast" do
    expect(Yap.ast("1")).to be_an(Parser::AST::Node)
  end

  it "does compiles node pattern expression" do
    expect(Yap.parse("(int 1)")).to eq([:int, 1])
    expect(Yap.parse("(send (int 1) + (int 2))")).to eq([:send, [:int, 1], :+, [:int, 2]] )
  end

  it "matches AST with expressions" do
    expect(Yap.match(Yap.parse("(int 1)"), Yap.ast("1"))).to be_truthy
    expect(Yap.match(Yap.parse("({int float} 1)"), Yap.ast("1"))).to be_truthy
    expect(Yap.match(Yap.parse("({int float} 1)"), Yap.ast("1.0"))).to be_truthy
  end

  it "matches complex expression" do
    expect(Yap.match(Yap.parse("(send (int 1) + (int 2))"), Yap.ast("1 + 2"))).to be_truthy
  end

  it "returns false if does not matches expression" do
    expect(Yap.match(Yap.parse("(send (int 1) + (int 2))"), Yap.ast("1 + 4"))).to be_falsy
  end
end
