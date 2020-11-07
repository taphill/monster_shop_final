require 'rails_helper'

RSpec.describe "merchant/discounts/edit", type: :feature do
  describe 'edit discount form' do
    let!(:merchant) { create(:merchant) }
    let!(:discount) { create(:discount, percentage: 10, item_quantity: 25, merchant: merchant) }
    let!(:user) { create(:user, role: 1, merchant: merchant) }

    before do
      visit login_path
      fill_in :email, with: user.email
      fill_in :password, with: user.password
      click_button 'Login'

      visit merchant_discount_path(discount)
      click_link 'Edit Discount'
    end

    it 'is pre-populated with current discount information' do
      expect(find_field('Percentage').value).to eq('10')     
      expect(find_field('Item quantity').value).to eq('25')     
    end
    
    context 'when successfully filled out' do
      it 'can update discount' do
        fill_in 'Percentage', with: '5'
        fill_in 'Item quantity', with: '20'
        click_button 'Edit'

        expect(page).to have_current_path(merchant_discounts_path)
        expect(page).to have_link('5% discount on 20 or more items')
        expect(page).to have_content('Discount successfully edited')
      end
    end

    context 'when unsuccessfully filled out' do
      it 'shows flash error' do
        fill_in 'Percentage', with: ''
        fill_in 'Item quantity', with: '20'
        click_button 'Edit'

        expect(page).to have_content("Percentage can't be blank")
      end
    end
  end
end
