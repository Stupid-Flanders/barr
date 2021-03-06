require 'barr/blocks/bspwm'
require './spec/mocks/bspwm'

RSpec.describe Barr::Blocks::Bspwm do

  before do
    allow_any_instance_of(described_class).to receive(:sys_cmd).and_return($bsp_json)
  end

  describe '#initialize' do
    it 'sets default focus_markers' do
      expect(subject.focus_markers).to eq(%w(> <))
    end

    it 'sets default focus inversion' do
      expect(subject.invert_focus_colors).to be(false)
    end

    it "sets default monitor" do
      expect(subject.monitor).to eq("DP-4")
    end

  end

  describe '#bsp_tree' do
    before { subject.bsp_tree }

    it "has monitors" do
      expect(subject.tree["monitors"].count).to eq(1)
    end
 
    it "desktops" do
      expect(subject.tree["monitors"].first["desktops"].count).to eq(10)
      expect(subject.tree["monitors"].first["desktops"].first["name"]).to eq("I")
    end

  end

  describe 'update!' do
    before { subject.update! }

    it "renders output correctly" do
      expect(subject.output).to eq("> I < %{A:bspc desktop -f II:} II %{A} %{A:bspc desktop -f III:} III %{A} %{A:bspc desktop -f IV:} IV %{A} %{A:bspc desktop -f V:} V %{A} %{A:bspc desktop -f VI:} VI %{A} %{A:bspc desktop -f VII:} VII %{A} %{A:bspc desktop -f VIII:} VIII %{A} %{A:bspc desktop -f IX:} IX %{A} %{A:bspc desktop -f X:} X %{A}")
    end
  end


  describe "desktops" do
    before do
      subject.invert_focus_colors = true
      subject.update!
      @fd = subject.tree["monitors"].first["desktops"].first
      @ud = subject.tree["monitors"].first["desktops"].last
    end

    after { subject.invert_focus_colors = false }
    
    describe "#focused_desktop" do
      before { @op = subject.focused_desktop(@fd) }

      it "renders in the correct format" do
        expect(@op).to eq("%{R}> I <%{R}")
      end
    end

    describe "#unfocused_desktop" do
      before { @op = subject.unfocused_desktop(@ud) }

      it "renders in the correct format" do
        expect(@op).to eq("%{A:bspc desktop -f X:} X %{A}")
      end
    end
  end
end
