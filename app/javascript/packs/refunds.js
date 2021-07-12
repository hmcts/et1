/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

import {EtGdsDesignSystem } from "et_gds_design_system"
import "et_gds_design_system/stylesheet"
import "./stylesheets/application.scss"
require('jquery');
require("@rails/ujs").start();
import SessionPrompt from "./components/SessionPrompt";
import RefundApplicantPage from "./pages/refunds/ApplicantPage";
import RefundFeesPage from "./pages/refunds/FeesPage";
import OriginalCaseDetailsPage from "./pages/refunds/OriginalCaseDetailsPage";
import BankDetailsPage from "./pages/refunds/BankDetailsPage";
import ProfileSelectionPage from "./pages/refunds/ProfileSelectionPage";
import ReviewPage from "./pages/refunds/ReviewPage";
import jQuery from "jquery";
window.$ = jQuery;
window.jQuery = jQuery;
EtGdsDesignSystem.initAll();
window.Et = {
  pages:{
    refunds: {
      ApplicantPage: RefundApplicantPage,
      FeesPage: RefundFeesPage,
      OriginalCaseDetailsPage: OriginalCaseDetailsPage,
      BankDetailsPage: BankDetailsPage,
      ProfileSelectionPage: ProfileSelectionPage,
      ReviewPage: ReviewPage
    }
  },
  components: {
    SessionPrompt
  }
};
