require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe "全ページのタイトル" do
    context "タイトル名ありの場合" do
      subject { full_title('プロフィール') }

      it { is_expected.to eq "プロフィール / TechBookHub" }
    end

    context "空文字の場合" do
      subject { full_title('') }

      it { is_expected.to eq "TechBookHub" }
    end

    context "タイトルの引数が与えられてない場合" do
      subject { full_title }

      it { is_expected.to eq "TechBookHub" }
    end

    context "タイトルがnilの場合" do
      subject { full_title(nil) }

      it { is_expected.to eq "TechBookHub" }
    end
  end
end
