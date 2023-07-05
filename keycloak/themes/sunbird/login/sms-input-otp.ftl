<#import "template.ftl" as layout>
    <@layout.registrationLayout; section>
    <#if section = "title">
        ${msg("loginTitle",realm.displayName)}
    <#elseif section = "form">
    <div class="custom-wrapper">
        <div class="ui raised shadow container segment fullpage-background-image">
            <div class="ui one column grid stackable">
                <div class="ui column height-fix">
                    <div class="max-container">
                        <div class="ui header centered">
                            <img onerror="" alt="">
                            <#--  <div class="signInHead mt-27">${msg("emailForgotTitle")}</div>  -->
                        </div>
                        <div class="signInHead mt-27">
                            ${msg("enterCode")}
                        </div>
                        <div class="ui content textCenter mt-8 mb-28">
                            <#if message?has_content>
                            <div class="ui text ${message.type}">
                                ${message.summary}
                            </div>
                            </#if>
                        </div>
                        <form id="kc-totp-login-form" class="${properties.kcFormClass!} ui form pre-signin" action="${url.loginAction}" method="post">
			                <input type="hidden" name="page_type" value="sms_otp_page" />
                            <div class="field">
                                <input id="totp" name="smsCode" type="text" class=" smsinput" onkeyup="validateOtpChar()" onfocusin="inputBoxFocusIn(this)" onfocusout="inputBoxFocusOut(this)"/>
                            </div>
                            <span id="otpLengthErr"></span>
                            <div class="field">
                                <button onclick="javascript:makeDivUnclickable(); javascript:otpLoginUser()" class="ui fluid submit button" name="login" id="login" type="submit" value="${msg("doLogIn")}">${msg("doSubmit")}</button>
                            </div>
                            <div class="field or-container">
                                <div class="or-holder">
                                    <span class="or-divider"></span>
                                    <span class="or-text">or</span>
                                </div>
                            </div>
                            <div class="field"></div>
                        </form>
                        <form id="kc-totp-login-form" class="${properties.kcFormClass!} ui form pre-signin" action="${url.loginAction}" method="post">
			                <input type="hidden" name="page_type" value="sms_otp_resend_page" />
                            <div class="field">
                                <div class="ui text textCenter" id="timer-container">
                                    <span>Resend OTP after </span><span id="js-timeout"></span>
                                </div>
                                <button onclick="javascript:makeDivUnclickable()" class="ui fluid submit button mt-8" 
                                name="resendOTP" id="resendOTP" type="submit" value="${msg("doLogIn")}" disabled>
                                    ${msg("doResendOTP")}
                                </button>
                            </div>
                        </form>
                        <#if client?? && client.baseUrl?has_content>
                            <div class="${properties.kcFormOptionsWrapperClass!} signUpMsg mb-56 mt-45 textCenter">
                                <span>
                                    <a id="backToApplication" onclick="javascript:makeDivUnclickable()" class="backToLogin" href="${client.baseUrl}">
                                        <span class="fs-14"><< </span>${msg("backToApplication")}
                                    </a>
                                </span>
                            </div>
                        </#if>
                    </div>
                </div>
                <div class="ui column tablet only computer only"></div>
            </div>
        </div>
    </div>
    </#if>
    <script>
        var interval
        function countdown() {
            document.getElementById("js-timeout").innerHTML = "3:00";
        // Update the count down every 1 second
        interval = setInterval( function() {
            var timer = document.getElementById("js-timeout").innerHTML;
            timer = timer.split(':');
            var minutes = timer[0];
            var seconds = timer[1];
            seconds -= 1;
            if (minutes < 0) return;
            else if (seconds < 0 && minutes != 0) {
                minutes -= 1;
                seconds = 59;
            }
            else if (seconds < 10 && length.seconds != 2) seconds = '0' + seconds;

             document.getElementById("js-timeout").innerHTML = minutes + ':' + seconds;

            if (minutes == 0 && seconds == 0) {
              clearInterval(interval);
              document.getElementById("resendOTP").removeAttribute('disabled')
              document.getElementById("timer-container").setAttribute("hidden", true);
            }
        }, 1000);
      }

      countdown()

      function validateOtpChar() {
        let userOptVal = document.getElementById("totp").value.trim()
        if (userOptVal && userOptVal.length !== 6) {
            document.getElementById("otpLengthErr").innerHTML = "OPT should have 6 digits"
        }
      }

      let resendOptVal = sessionStorage.getItem("resendOptVal")
      if(resendOptVal == 1 ) {
        sessionStorage.setItem("resendOptVal", 0)
       
       
        
      }

function timerCount() {
  var timeInterval = setInterval(function () {
    if (sessionStorage.getItem("timeLeftForUnblock")) {
      timeLeftForUnblock = sessionStorage.getItem("timeLeftForUnblock")
      console.log(timeLeftForUnblock, 'timeLeftForUnblock')
    } else {
      sessionStorage.setItem("timeLeftForUnblock", timeLeftForUnblock)
    }
    timeLeftForUnblock = timeLeftForUnblock - 1
    console.log(timeLeftForUnblock, 'timeLeftForUnblock')
    sessionStorage.setItem("timeLeftForUnblock", timeLeftForUnblock)
    timeLeftForUnblock = sessionStorage.getItem("timeLeftForUnblock")
      console.log(timeLeftForUnblock, "timeLeftForUnblock===")
    if (timeLeftForUnblock == -1) {
      clearInterval(timeInterval)
      console.log(timeLeftForUnblock, "timeLeftForUnblock===")
      sessionStorage.removeItem("loginAttempts")
      sessionStorage.removeItem("timeLeftForUnblock")
      enableFields()
      loginAttempts = 0
      timeLeftForUnblock = 30
    console.log("expired")
    }
  }, 1000);
}

  var timeLeftForUnblock = 30
  var loginAttempts = 0 // Variable to keep track of login attempts
  var totalLoginAttempts = 3

  function otpLoginUser() {
    console.log("otp button clicked")
    let loginCount = parseInt(sessionStorage.getItem("loginAttempts"))
    console.log(loginCount, "loginCount--")
    if (!loginCount || loginCount === null || loginCount < totalLoginAttempts) {
      loginAttempts += 1
      sessionStorage.setItem("loginAttempts", loginAttempts)
      loginCount = parseInt(sessionStorage.getItem("loginAttempts"))
      console.log(loginCount, "loginCount--")
      var pendingLoginAttempt = totalLoginAttempts - loginAttempts
     console.log(pendingLoginAttempt, "pendingLoginAttempt===")
      enableFields()
    }

    if (loginCount && loginCount == totalLoginAttempts) {
      disableFields()
      timerCount()
    }
  }
 

  

  function disableFields() {
    document.getElementById("username").disabled = true
    document.getElementById("password").disabled = true
    document.getElementById("login").disabled = true
  }

  function enableFields() {
    document.getElementById("username").disabled = false
    document.getElementById("password").disabled = false
    document.getElementById("login").disabled = false
  }


  function onStart() {
    if (sessionStorage.getItem("loginAttempts")) {
      loginAttempts = Number(sessionStorage.getItem("loginAttempts"))
    }
    if (sessionStorage.getItem("timeLeftForUnblock",)) {
      timeLeftForUnblock = sessionStorage.getItem("timeLeftForUnblock")
    }
    if ((loginAttempts == totalLoginAttempts) && timeLeftForUnblock != -1) {
      disableFields()
      timerCount()
    
    }
    if ((loginAttempts == totalLoginAttempts) && timeLeftForUnblock == -1) {
      enableFields()
      sessionStorage.removeItem("loginAttempts")
      sessionStorage.removeItem("timeLeftForUnblock")
      clearInterval(timeInterval)
    }
  }
  onStart()
    </script>
</@layout.registrationLayout>

