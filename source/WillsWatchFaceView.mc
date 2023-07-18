import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.ActivityMonitor as Mon;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.Time;

class WillsWatchFaceView extends WatchUi.WatchFace {

    var heartImage;
    var stepsImage;
    var trophyImage;

    function initialize() {
        WatchFace.initialize();
        heartImage = WatchUi.loadResource(Rez.Drawables.heartImage);
        stepsImage = WatchUi.loadResource(Rez.Drawables.stepsImage);
        trophyImage = WatchUi.loadResource(Rez.Drawables.trophyImage);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        var deviceHeight = dc.getHeight();
		var deviceWidth = dc.getWidth();
        var x=(deviceWidth*0.57), yHeart=(deviceHeight*0.38), ySteps=(deviceHeight*0.49), yTrophy=(deviceHeight*0.61);
        

        // Get and show the current time
        setClockDisplay();
        setBatteryDisplay();
        setHeartRateDisplay();
        // setWeatherDisplay(); // API 3.2.0  
        setStepCount();  
        setStepGoalPercent();
        setDate();
        

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        dc.drawBitmap(x, yHeart, heartImage);
        dc.drawBitmap(x, ySteps, stepsImage);
        dc.drawBitmap(x, yTrophy, trophyImage);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    private function setClockDisplay() {
        
        var clockTime = System.getClockTime();

        var hourString = Lang.format("$1$", [clockTime.hour]);
        var minuteString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        
        var hourDisplay = View.findDrawableById("timeDisplayHour") as Text;
        var minuteDisplay = View.findDrawableById("timeDisplayMinute") as Text;

        hourDisplay.setText(hourString);
        minuteDisplay.setText(minuteString);


    }

    private function setBatteryDisplay() {

        var battery = System.getSystemStats().battery;
        var batteryDisplay = View.findDrawableById("batteryDisplay") as Text;
        batteryDisplay.setText(battery.format("%d") + "%");

    }

    private function setHeartRateDisplay() {

        // var heartrate = "";
        

        // if (ActivityMonitor has :INVALID_HR_SAMPLE) {

        //     var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
        //     var currentHeartRate = hrIterator.next().heartRate;

        //     if (currentHeartRate == ActivityMonitor.INVALID_HR_SAMPLE) {
        //         heartrate = "--";
        //     }
        //     else {
        //         heartrate = currentHeartRate.format("%d");
        //     }

        // } 
        // else {

        //     heartrate = "";     

        // if (null != currentHeartRate) {                                           
        //     if (currentHeartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
        //         heartrate = currentHeartRate.format("%d");
        //     }
        //     else {
        //         heartrate = "--";
        //     }
        // }


        // var heartRateDisplay = View.findDrawableById("heartRateDisplay") as Text;
        // heartRateDisplay.setText(heartrate);

        var hr = 0;
        var hrText = "";

        var activityInfo = Activity.getActivityInfo();
        if (activityInfo != null) {
            hr = activityInfo.currentHeartRate;
        } else {
            hr = null;
        }

        if (hr == null || hr == 0) {
            hrText = "--";
        } else {
            hrText = hr.format("%d");
        }

        var heartRateDisplay = View.findDrawableById("heartRateDisplay") as Text;
        heartRateDisplay.setText(hrText);

    }

    private function setWeatherDisplay() {

        var weather = Weather.getCurrentConditions().temperature;
        var weatherDisplay = View.findDrawableById("weatherDisplay") as Text;
        weatherDisplay.setText(weather.format("%d"));

    }

    private function setStepCount() {

        var stepCount = ActivityMonitor.getInfo().steps;

        if (stepCount == null) {
            stepCount = 0;
        } else if (stepCount > 9999) {
            stepCount = stepCount.toString().substring(0, 2).toNumber();
        }

        var stepCountDisplay = View.findDrawableById("stepsDisplay") as Text;
        stepCountDisplay.setText(stepCount.format("%d"));

    }

    private function setStepGoalPercent() {

        var steps = ActivityMonitor.getInfo().steps;
        var stepGoal = ActivityMonitor.getInfo().stepGoal;
        var percent = 0;

        if (steps > 0 && stepGoal != null) {
            percent = ((steps.toFloat() / stepGoal.toFloat()) * 100f);
        }
        
        var stepGoalPercent = View.findDrawableById("stepGoalDisplay") as Text;
        stepGoalPercent.setText(percent.format("%d") + "%");

    }

    private function setDate() {

        var today = Time.Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$, $3$ ",
            [today.month,
             today.day,
             today.year]
            );
        var dateDisplay = View.findDrawableById("dateDisplay") as Text;
        dateDisplay.setText(dateString);

    }

}
