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
const images = require.context('./csv', true);
import {EtGdsDesignSystem } from "et_gds_design_system"
import "et_gds_design_system/stylesheet"
import "./stylesheets/application.scss"
require("@rails/ujs").start();
import ClaimantPage from "./pages/claims/ClaimantPage";
import AdditionalClaimantsPage from "./pages/claims/AdditionalClaimantsPage";
import RepresentativePage from "./pages/claims/RepresentativePage";
import RespondentPage from "./pages/claims/RespondentPage";
import AdditionalRespondentsPage from "./pages/claims/AdditionalRespondentsPage";
import EmploymentPage from "./pages/claims/EmploymentPage";
import ClaimTypePage from "./pages/claims/ClaimTypePage";
import ClaimConfirmationPage from "./pages/claims/ClaimConfirmationPage";
import SessionPrompt from "./components/SessionPrompt";
import RefundApplicantPage from "./pages/refunds/ApplicantPage";
import RefundFeesPage from "./pages/refunds/FeesPage";
EtGdsDesignSystem.initAll();
window.Et = {
  pages:{
    claims: {
      ClaimantPage: ClaimantPage,
      AdditionalClaimantsPage: AdditionalClaimantsPage,
      RepresentativePage: RepresentativePage,
      RespondentPage: RespondentPage,
      AdditionalRespondentsPage: AdditionalRespondentsPage,
      EmploymentPage: EmploymentPage,
      ClaimTypePage: ClaimTypePage,
      ClaimConfirmationPage: ClaimConfirmationPage
    },
    refunds: {
      ApplicantPage: RefundApplicantPage,
      FeesPage: RefundFeesPage
    }
  },
  components: {
    SessionPrompt
  }
};
