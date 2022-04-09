require 'rails_helper'
include ActionView::Helpers::DateHelper
RSpec.describe "PVランキング機能の検証", type: :system do
  describe 'ランキングの要素検証' do
    let!(:user) { create(:user) }
    let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
    let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
    let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }

    it '要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{second_rank_review.id}"
      visit "/reviews/#{second_rank_review.id}"
      visit "/reviews/#{third_rank_review.id}"
      visit "/all_reviews"
      within(".pv-ranking") do
        within(".like-ranking-title") do
          expect(page).to have_selector 'div', text: "PVランキング"
        end
        within("#ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "3PV / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end

        within("#ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "2PV / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end

        within("#ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "1PV / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
      end
    end
  end

  describe 'ランキングの変動の検証' do
    let!(:user) { create(:user) }
    let!(:first_rank_review) { create(:good_review, title: "楽しいruby入門") }
    let!(:second_rank_review) { create(:good_review, title: "楽しいrails入門") }
    let!(:third_rank_review) { create(:good_review, title: "楽しいphp入門") }

    it '要素検証をすること', js: true do
      log_in_as(user.email, user.password)
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{first_rank_review.id}"
      visit "/reviews/#{second_rank_review.id}"
      visit "/reviews/#{second_rank_review.id}"
      visit "/reviews/#{third_rank_review.id}"
      visit "/all_reviews"
      within(".pv-ranking") do
        within(".like-ranking-title") do
          expect(page).to have_selector 'div', text: "PVランキング"
        end
        within("#ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "3PV / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end

        within("#ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "2PV / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end

        within("#ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "1PV / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
      end
      visit "/reviews/#{second_rank_review.id}"
      visit "/reviews/#{second_rank_review.id}"
      visit "/all_reviews"
      within(".pv-ranking") do
        within(".like-ranking-title") do
          expect(page).to have_selector 'div', text: "PVランキング"
        end
        within("#ranking_1") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "1"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{second_rank_review.title}"
            expect(page).to have_selector 'span', text: "4PV / #{second_rank_review.user.username} / #{I18n.l(second_rank_review.created_at, format: :long)}"
          end
        end
        within("#ranking_2") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "2"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{first_rank_review.title}"
            expect(page).to have_selector 'span', text: "3PV / #{first_rank_review.user.username} / #{I18n.l(first_rank_review.created_at, format: :long)}"
          end
        end
        within("#ranking_3") do
          within(".ranking-icon-div-left") do
            expect(page).to have_selector('svg', count: 1)
            expect(page).to have_selector 'div', text: "3"
          end
          within(".ranking-icon-div-right") do
            expect(page).to have_selector('a', count: 1)
            expect(page).to have_selector 'span', text: "#{third_rank_review.title}"
            expect(page).to have_selector 'span', text: "1PV / #{third_rank_review.user.username} / #{I18n.l(third_rank_review.created_at, format: :long)}"
          end
        end
      end
    end
  end
end
