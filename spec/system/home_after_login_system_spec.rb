require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "Homes_after_login", type: :system do
  describe 'ログイン後のトップページの検証' do
    let!(:user) { create(:user, id: 1) }
    let!(:sample_user) { create(:second_user, email: "example@samp.com", id: 2) }
    let!(:recent_review) { create(:recent_review, id: 1) }
    let!(:good_review) { create(:good_review, id: 2) }
    let!(:great_review) { create(:great_review, id: 3) }

    it 'トップページの要素検証すること' do
      log_in_as(user.email, user.password)
      visit '/'
      within('.search_words') do
        expect(page).to have_selector 'li', text: 'Ruby'
        expect(page).to have_selector 'li', text: 'Rails'
        expect(page).to have_selector 'li', text: 'PHP'
        expect(page).to have_selector 'li', text: 'Laravel'
        expect(page).to have_selector 'li', text: 'Python'
        expect(page).to have_selector 'li', text: 'Django'
        expect(page).to have_selector 'li', text: 'Go'
        expect(page).to have_selector 'li', text: 'Java'
        expect(page).to have_selector 'li', text: 'TypeScript'
        expect(page).to have_selector 'li', text: 'JavaScript'
        expect(page).to have_selector 'li', text: 'React.js'
        expect(page).to have_selector 'li', text: 'Next.js'
        expect(page).to have_selector 'li', text: 'Vue.js'
        expect(page).to have_selector 'li', text: 'Nuxt.js'
        expect(page).to have_selector 'li', text: 'SQL'
        expect(page).to have_selector 'li', text: 'AWS'
        expect(page).to have_selector 'li', text: 'Docker'
        expect(page).to have_selector 'li', text: 'Swift'
        expect(page).to have_selector 'li', text: 'Flutter'
        expect(page).to have_selector 'li', text: 'Kubernetes'
        expect(page).to have_selector 'li', text: 'Linux'
        expect(page).to have_selector 'li', text: 'HTML'
      end
      within('.api-search-group') do
        expect(page).to have_selector("input[placeholder$='キーワードを入力']")
        expect(page).to have_selector("input[id$='search_content']")
        expect(page).to have_selector("input[value$='検索']")
      end
    end

    xit 'ネットが機能すること' do
      # 一応この状態でもxを外せばテストは通るが amazon, googleなど他のapi検索のテストも行う
      log_in_as(user.email, user.password)
      visit '/'
      fill_in 'search_content', with: "ruby"
      find(".api-search-btn").click
      sleep 10
      within(".api-item-1") do
        expect(page).to have_selector 'div', text: 'プロを目指す人のためのRuby入門［改訂2版］　言語仕様からテスト駆動開発・デバッグ技法まで'
        expect(page).to have_selector 'span', text: '3278円'
        expect(page).to have_selector 'span', text: '2021年12月02日頃'
        expect(page).to have_selector 'div', text: "Ｒｕｂｙの基礎知識からプロの現場で必須のテクニックまで、丁寧に解説。Ｒａｉｌｓアプリの開発が「..."
      end
      within(".api-item-sentences-1") do
        expect(page).to have_selector 'span', class: 'api-item-rakuten-word', text: '楽天ブックス'
        expect(page).to have_selector 'span', class: 'api-item-yahoo-word', text: 'Yahoo!'
        expect(page).to have_selector 'span', class: 'api-item-library-word', text: '全国図書館'
        expect(page).to have_selector 'span', class: 'api-item-kinokuniya-word', text: '紀伊國屋書店'
        expect(page).to have_selector 'span', class: 'api-item-miraiya-word', text: '未来屋書店'
      end
      within('#scroll-comment') do
        expect(page).to have_selector 'a', text: '一番上へ戻る'
      end
    end
  end
end
