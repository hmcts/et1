require 'rails_helper'

RSpec.feature 'Switching language', type: :feature do

  scenario 'hitting the stats end point returns json' do
    visit root_path
    expect(page).to have_link("Cymraeg", href: '/cy/apply')
    expect(page).to have_text("Make a claim to an employment tribunal")
    click_link('Cymraeg')

    expect(page).to have_link("English", href: '/en/apply')
    expect(page).to have_text("Gwneud hawliad i dribiwnlys cyflogaeth")

    click_link('English')
    expect(page).to have_text("Make a claim to an employment tribunal")
    expect(page).to have_link("Cymraeg", href: '/cy/apply')
  end

  scenario 'langauge should persist after submitting the form', js: true do
    visit root_path
    click_button 'Start a claim'

    expect(page).to have_text('Saving your claim')
    expect(current_path).to eql('/en/apply/application-number')
    click_link('Cymraeg')

    expect(page).to have_text('Cadw eich hawliad')
    expect(current_path).to eql('/cy/apply/application-number')
    click_button('Cadw a pharhau')

    expect(page).to have_text("Rhowch wybodaeth yn y blychau testun sydd wedi'u hamlygu.")
    expect(page).to have_text("Dylech greu gair cofiadwy er mwyn i chi allu dychwelyd i'ch hawliad")
    expect(page).to have_text('Cadw eich hawliad')
  end
end
