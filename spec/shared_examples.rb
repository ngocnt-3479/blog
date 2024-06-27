RSpec.shared_examples "redirect to home page" do
  it "redirect to home page" do
    expect(response).to redirect_to root_path
  end
end

RSpec.shared_examples "show flash user not found" do
  it "show flash user not found" do
    expect(flash[:danger]).to eq("User not found")
  end
end
