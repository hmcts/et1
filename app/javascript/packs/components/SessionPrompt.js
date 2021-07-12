// Manages session timeout & displays prompt prior to session expiry
const SessionPrompt = (function () {

  let settings = {
    SECOND: 1000
  };
  settings.MINUTE = 60 * settings.SECOND;
  settings.FIVE_MINUTES = 5 * settings.MINUTE;
  settings.FIFTY_FIVE_MINUTES = 55 * settings.MINUTE;

  const sessionPrompt = {

    timerRef: null,

    init: function (options) {
      settings = Object.assign(settings, options);
      this.counter = settings.FIVE_MINUTES;
      this.updateTimeLeftOnPrompt(this.counter);
      this.setPromptExtendSessionClickEvent();
      this.startSessionTimer();
    },

    startSessionTimer: function () {
      setTimeout(()=> {
        this.timeoutPrompt.apply(this)
      }, settings.FIFTY_FIVE_MINUTES);
    },

    setPromptExtendSessionClickEvent: function () {
      document.querySelector("#session_prompt_continue_btn").onclick = ()=> { this.refreshSession.apply(this, arguments) };
    },

    timeoutPrompt: function () {
      this.timerRef = setInterval(()=> { this.promptUpdate.apply(this) }, settings.SECOND);
      this.togglePromptVisibility();
    },

    promptUpdate: function () {
      if (this.counter === 0) {
        this.expireSession();
      } else {
        this.counter -= settings.SECOND;
        this.updateTimeLeftOnPrompt(this.counter);
      }
    },

    togglePromptVisibility: function () {
      const node = document.querySelector("#session_prompt");
      if(node.style.display == 'block') {
        node.style.display = 'none';

      } else {
        node.style.display = 'block';
      }
    },

    updateTimeLeftOnPrompt: function (timeInMillis) {
      const seconds = timeInMillis / settings.SECOND;
      const mins = Math.floor(seconds / 60);
      const secs = seconds % 60;
      const time = (mins === 0) ? secs : (mins + ":" + this.padSeconds(secs));
      document.querySelector('#session_prompt_time_left').innerHTML = time;
    },

    padSeconds: function (secs) {
      return ((secs + "").length === 1) ? "0" + secs : secs;
    },

    expireSession: function () {
      location.href = location.protocol + "//" + location.host + "/apply/session/expired";
    },

    refreshSession: function () {
      clearInterval(this.timerRef);
      const that = this;
      fetch("/apply/session/touch", { credentials: 'include' }).then((response)=>{
        if(!response.ok) { return }

        that.togglePromptVisibility.apply(that);
        that.init.apply(that);
      });
    }
  };

  return sessionPrompt;

})();
export default SessionPrompt;
