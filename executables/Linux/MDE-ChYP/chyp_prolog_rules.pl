/*Suppress warning for singleton variables*/
:- style_check(-singleton).

/*Suppress warning for discontiguous facts*/
:- discontiguous application/2, permission_rule/3, 
trigger/3, condition/3, action/3, attribute_command/3, 
device_capability/3, value/3, triggerComposition/7, conditionComposition/7,
actionComposition/7, requestedCapability/2, capability/1,
attributeCommandOf/2, valueOf/2.
/*linux-specific, it failed silently without an error when "not/1" was uncommented*/
/*, not/1.*/

/*Show the whole result*/
:- set_prolog_flag(answer_write_options,
                   [ quoted(true),
                     portray(true),
                     spacing(next_argument)]).

/*Ignore unavailable facts*/
:- dynamic
    application/2,
    permission_rule/3,
    trigger/3,
    condition/3,
    action/3,
    attribute_command/3,
    device_capability/3,
    value/3,
    triggerComposition/7,
    conditionComposition/7,
    actionComposition/7,
    requestedCapability/2.

/*setof([AppName,RuleId,Id,Capability,Resource], overprivilegedCase1(AppName,RuleId,Id,Capability,Resource), AllOverprivilegedCase1).*/
/*findall gives duplicates, setof does not*/

/*case 1 Rules*/
overprivilegedCase1(case1,AppName,RuleId,Id,Capability,Resource):-
    triggerComposition(code,AppName,RuleId,Id,Capability,Resource,_),
    notAttributeCommandOfCapability(Capability,Resource),
    attributeCommandOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na);

    triggerComposition(code,AppName,RuleId,Id,Capability,_,Resource),
    not(valueOfAttributeOfCapability(Capability,Resource)),
    valueOfAttributeOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na);
    
    actionComposition(code,AppName,RuleId,Id,Capability,Resource,_),
    notAttributeCommandOfCapability(Capability,Resource),
    attributeCommandOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na);

    actionComposition(code,AppName,RuleId,Id,Capability,_,Resource),
    not(valueOfAttributeOfCapability(Capability,Resource)),
    valueOfAttributeOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na);

    conditionComposition(code,AppName,RuleId,Id,Capability,Resource,_),
    notAttributeCommandOfCapability(Capability,Resource),
    attributeCommandOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na);

    conditionComposition(code,AppName,RuleId,Id,Capability,_,Resource),
    not(valueOfAttributeOfCapability(Capability,Resource)),
    valueOfAttributeOfCapability(Capability2,Resource),
    not(Capability2=Capability),
    not(Capability=na),
    not(Resource=na).

attributeCommandOfCapability(Capability,Resource):-
    capability(Capability),
    attributeCommandOf(Capability,Resource).

notAttributeCommandOfCapability(Capability,Resource):-
    capability(Capability),
    not(attributeCommandOf(Capability,Resource)).

valueOfAttributeOfCapability(Capability,Resource):-
    capability(Capability),
    attributeCommandOf(Capability,Attribute),
    valueOf(Attribute,Resource).

/*setof([AppName,Capability], overprivilegedCase2(AppName, Capability), AllOverprivilegedCase2).*/
/*case 2 Rules*/

overprivilegedCase2(case2,AppName,Capability):-
    requestedCapability(AppName,Capability),
    application(desc,AppName),
    %permission_rule(desc,AppName,_),
    not(device_capability(desc,_,Capability)),
    not(Capability=na).

/*setof([AppName,RuleIdCode,TriggerIdCode,ConditionIdCode,ActionIdCode,Capability,AttributeCommand,Value], overprivilegedCase3(AppName,RuleIdCode,TriggerIdCode,ConditionIdCode,ActionIdCode,Capability,AttributeCommand,Value), AllOverprivilegedCase3).*/
/*case 3 Rules, issues: it gives an error if a fact does not exist*/
overprivilegedCase3(case3,AppName,RuleIdCode,TriggerIdCode,ConditionIdCode,ActionIdCode,Capability,AttributeCommand,Value):-
    /*The whole trigger is missing in description*/
    /*triggerNotInDesc(AppName,RuleIdCode,TriggerIdCode,Capability,AttributeCommand,Value);*/
    /*The whole condition is missing in description*/
    /*conditionNotInDesc(AppName,RuleIdCode,ConditionIdCode,Capability,AttributeCommand,Value);*/
    /*The whole action is missing in description*/
    actionNotInDesc(AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value);
    /*An action and a trigger are present in a rule in code, but not in description*/
    /*  1, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, AttributeCommand2, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2)),
    not(Capability2=na),
    not(AttributeCommand2=na),
    not(Value2=na);
    /*  2, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, AttributeCommand2, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na)),
    not(Capability2=na),
    not(AttributeCommand2=na);
    /*  3, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, na, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,Capability2,AttributeCommand,na,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,na,Value,na)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,Capability2,AttributeCommand,na,Value,na)),
    not(Capability2=na);
    /*  4, In code and not in desc:
        Capability, AttributeCommand, Value
        na, AttributeCommand2, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2)),
    not(AttributeCommand2=na),
    not(Value2=na);
    /*  5, In code and not in desc:
        Capability, AttributeCommand, Value
        na, na, value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,na,AttributeCommand,na,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,na,AttributeCommand,na,Value,Value2)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,na,AttributeCommand,na,Value,Value2)),
    not(Value2=na);
    /*  6, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, na, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,Capability2,AttributeCommand,na,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,na,Value,Value2)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,Capability2,AttributeCommand,na,Value,Value2)),
    not(Capability2=na),
    not(Value2=na);
    /*  7, In code and not in desc:
        Capability, AttributeCommand, Value
        na, AttributeCommand2, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    triggerActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,TriggerIdCode,Capability,na,AttributeCommand,AttributeCommand2,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,na,AttributeCommand,AttributeCommand2,Value,na)),*/
    not(triggerActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,TriggerIdDesc,Capability,na,AttributeCommand,AttributeCommand2,Value,na)),
    not(AttributeCommand2=na);
    /*An action and a condition are present in a rule in code, but not in description*/
    /*  1, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, AttributeCommand2, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2)),
    not(Capability2=na),
    not(AttributeCommand2=na),
    not(Value2=na);
    /*  2, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, AttributeCommand2, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,na)),
    not(Capability2=na),
    not(AttributeCommand2=na);
    /*  3, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, na, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,Capability2,AttributeCommand,na,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,na,Value,na)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,Capability2,AttributeCommand,na,Value,na)),
    not(Capability2=na);
    /*  4, In code and not in desc:
        Capability, AttributeCommand, Value
        na, AttributeCommand2, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,na,AttributeCommand,AttributeCommand2,Value,Value2)),
    not(AttributeCommand2=na),
    not(Value2=na);
    /*  5, In code and not in desc:
        Capability, AttributeCommand, Value
        na, na, value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,na,AttributeCommand,na,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,na,AttributeCommand,na,Value,Value2)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,na,AttributeCommand,na,Value,Value2)),
    not(Value2=na);
    /*  6, In code and not in desc:
        Capability, AttributeCommand, Value
        Capability2, na, Value2*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,Capability2,AttributeCommand,na,Value,Value2),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,na,Value,Value2)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,Capability2,AttributeCommand,na,Value,Value2)),
    not(Capability2=na),
    not(Value2=na);
    /*  7, In code and not in desc:
        Capability, AttributeCommand, Value
        na, AttributeCommand2, na*/
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    conditionActionCombinationInSource(code,AppName,RuleIdCode,ActionIdCode,ConditionIdCode,Capability,na,AttributeCommand,AttributeCommand2,Value,na),
    /*not(triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,na,Value,Value2)),*/
    not(conditionActionCombinationInSource(desc,AppName,RuleIdDesc,ActionIdDesc,ConditionIdDesc,Capability,na,AttributeCommand,AttributeCommand2,Value,na)),
    not(AttributeCommand2=na).

triggerActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2):-
    actionComposition(Source,AppName,RuleId,ActionId,Capability,AttributeCommand,Value),
    triggerComposition(Source,AppName,RuleId,TriggerId,Capability2,AttributeCommand2,Value2).

conditionActionCombinationInSource(Source,AppName,RuleId,ActionId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2):-
    actionComposition(Source,AppName,RuleId,ActionId,Capability,AttributeCommand,Value),
    conditionComposition(Source,AppName,RuleId,ConditionId,Capability2,AttributeCommand2,Value2).

triggerORConditionANDActionCombinationInSource(Source,AppName,RuleId,ActionId,TriggerId,ConditionId,Capability,Capability2,AttributeCommand,AttributeCommand2,Value,Value2):-
    actionComposition(Source,AppName,RuleId,ActionId,Capability,AttributeCommand,Value),
    triggerComposition(Source,AppName,RuleId,TriggerId,Capability2,AttributeCommand2,Value2);

    actionComposition(Source,AppName,RuleId,ActionId,Capability,AttributeCommand,Value),
    conditionComposition(Source,AppName,RuleId,ConditionId,Capability2,AttributeCommand2,Value2).

/*  Use Case:
    Desc: "Unlock the door when I arrive" > trigger should be the arrival
    Code: "Triggers when I switch off the light" */
triggerNotInDesc(AppName,RuleIdCode,TriggerIdCode,Capability,AttributeCommand,Value):-
    triggerComposition(code,AppName,RuleIdCode,TriggerIdCode,Capability,AttributeCommand,Value),
    not(triggerComposition(desc,AppName,_,_,Capability,AttributeCommand,Value)),
    not(threeNAs(Capability,AttributeCommand,Value)),
    not(triggerTwoNAs(AppName,Capability,AttributeCommand,Value)).

/* use with not*/
threeNAs(Capability,AttributeCommand,Value):-
    Capability=na,
    AttributeCommand=na,
    Value=na.

/* use with not*/
triggerTwoNAs(AppName,Capability,AttributeCommand,Value):-
    AttributeCommand = na,
    Value = na,
    triggerComposition(desc,AppName,_,_,Capability,_,_).

/*  Use Case:
    Desc: "Turn on the over when I arrive if it is Monday." 
    Code: "Checks if it is Sunday." */
conditionNotInDesc(AppName,RuleIdCode,ConditionIdCode,Capability,AttributeCommand,Value):-
    conditionComposition(code,AppName,RuleIdCode,ConditionIdCode,Capability,AttributeCommand,Value),
    not(conditionComposition(desc,AppName,_,_,Capability,AttributeCommand,Value)),
    not(threeNAs(Capability,AttributeCommand,Value)),
    not(conditionTwoNAs(AppName,Capability,AttributeCommand,Value)).
 
/* use with not*/
conditionTwoNAs(AppName,Capability,AttributeCommand,Value):-
    AttributeCommand = na,
    Value = na,
    conditionComposition(desc,AppName,_,_,Capability,_,_).

/*  Use Case:
    Desc: "Lock the front door"
    Code: "Unlocks the door" */
actionNotInDesc(AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value):-
    actionComposition(code,AppName,RuleIdCode,ActionIdCode,Capability,AttributeCommand,Value),
    not(actionComposition(desc,AppName,_,_,Capability,AttributeCommand,Value)),
    not(threeNAs(Capability,AttributeCommand,Value)),
    not(actionTwoNAs(AppName,Capability,AttributeCommand,Value)).

/* use with not*/
actionTwoNAs(AppName,Capability,AttributeCommand,Value):-
    AttributeCommand = na,
    Value = na,
    actionComposition(desc,AppName,_,_,Capability,_,_).

/*Case 1 facts, SmartThings permission/capability model facts*/
capability(accelerationSensor).
attributeCommandOf(accelerationSensor,acceleration).
valueOf(acceleration,active).
valueOf(acceleration,inactive).

capability(actuator).

capability(airConditionerMode).
attributeCommandOf(airConditionerMode,airConditionerMode).
attributeCommandOf(airConditionerMode,setAirConditionerMode).
valueOf(airConditionerMode,auto).
valueOf(airConditionerMode,cool).
valueOf(airConditionerMode,dry).
valueOf(airConditionerMode,coolClean).
valueOf(airConditionerMode,dryClean).
valueOf(airConditionerMode,fanOnly).
valueOf(airConditionerMode,heat).
valueOf(airConditionerMode,heatClean).
valueOf(airConditionerMode,notSupported).

capability(airQualitySensor).
attributeCommandOf(airQualitySensor,airQuality).

capability(alarm).
attributeCommandOf(alarm,alarm).
attributeCommandOf(alarm,both).
attributeCommandOf(alarm,off).
attributeCommandOf(alarm,siren).
attributeCommandOf(alarm,strobe).
valueOf(alarm,both).
valueOf(alarm,off).
valueOf(alarm,siren).
valueOf(alarm,strobe).

capability(audioMute).
attributeCommandOf(audioMute,mute).
attributeCommandOf(audioMute,setMute).
attributeCommandOf(audioMute,mute).
attributeCommandOf(audioMute,unmute).
valueOf(mute,muted).
valueOf(mute,unmuted).

capability(audioNotification).
attributeCommandOf(audioNotification,playTrack).
attributeCommandOf(audioNotification,playTrackAndResume).
attributeCommandOf(audioNotification,playTrackAndRestore).

capability(audioTrackData).
attributeCommandOf(audioTrackData,audioTrackData).

capability(audioVolume).
attributeCommandOf(audioVolume,volume).
attributeCommandOf(audioVolume,setVolume).
attributeCommandOf(audioVolume,volumeUp).
attributeCommandOf(audioVolume,volumeDown).

capability(battery).
attributeCommandOf(battery,battery).

capability(beacon).
attributeCommandOf(beacon,presence).
valueOf(presence,notpresent).
valueOf(presence,present).

capability(bridge).

capability(bulb).
attributeCommandOf(bulb,switch).
attributeCommandOf(bulb,off).
attributeCommandOf(bulb,on).
valueOf(switch,off).
valueOf(switch,on).

capability(button).
attributeCommandOf(button,button).
attributeCommandOf(button,numberOfButtons).
valueOf(button,held).
valueOf(button,pushed).

capability(carbonDioxideMeasurement).
attributeCommandOf(carbonDioxideMeasurement,carbonDioxide).

capability(carbonMonoxideDetector).
attributeCommandOf(carbonMonoxideDetector,carbonMonoxide).
valueOf(carbonMonoxide,clear).
valueOf(carbonMonoxide,detected).
valueOf(carbonMonoxide,tested).

capability(colorControl).
attributeCommandOf(colorControl,color).
attributeCommandOf(colorControl,hue).
attributeCommandOf(colorControl,saturation).
attributeCommandOf(colorControl,setColor).
attributeCommandOf(colorControl,setHue).
attributeCommandOf(colorControl,setSaturation).

capability(colorTemperature).
attributeCommandOf(colorTemperature,colorTemperature).
attributeCommandOf(colorTemperature,setColorTemperature).

capability(color).
attributeCommandOf(color,colorValue).
attributeCommandOf(color,setColorValue).

capability(colorMode).
attributeCommandOf(colorMode,colorMode).
valueOf(colorMode,color).
valueOf(colorMode,colorTemperature).
valueOf(colorMode,other).

capability(configuration).
attributeCommandOf(configuration,configure).

capability(consumable).
attributeCommandOf(consumable,consumableStatus).
attributeCommandOf(consumable,setConsumableStatus).
valueOf(consumableStatus,good).
valueOf(consumableStatus,maintenance_required).
valueOf(consumableStatus,missing).
valueOf(consumableStatus,order).
valueOf(consumableStatus,replace).

capability(contactSensor).
attributeCommandOf(contactSensor,contact).
valueOf(contact,closed).
valueOf(contact,open).

capability(demandResponseLoadControl).
attributeCommandOf(demandResponseLoadControl,drlcStatus).
attributeCommandOf(demandResponseLoadControl,requestDrlcAction).
attributeCommandOf(demandResponseLoadControl,overrideDrlcAction).

capability(dishwasherMode).
attributeCommandOf(dishwasherMode,dishwasherMode).
attributeCommandOf(dishwasherMode,setDishwasherMode).
valueOf(dishwasherMode,auto).
valueOf(dishwasherMode,quick).
valueOf(dishwasherMode,rinse).
valueOf(dishwasherMode,dry).

capability(dishwasherOperatingState).
attributeCommandOf(dishwasherOperatingState,machineState).
attributeCommandOf(dishwasherOperatingState,supportedMachineStates).
attributeCommandOf(dishwasherOperatingState,dishwasherJobState).
attributeCommandOf(dishwasherOperatingState,completionTime).
attributeCommandOf(dishwasherOperatingState,setMachineState).
valueOf(machineState,pause).
valueOf(machineState,run).
valueOf(machineState,stop).
valueOf(dishwasherJobState,airwash).
valueOf(dishwasherJobState,cooling).
valueOf(dishwasherJobState,drying).
valueOf(dishwasherJobState,finish).
valueOf(dishwasherJobState,preDrain).
valueOf(dishwasherJobState,prewash).
valueOf(dishwasherJobState,rinse).
valueOf(dishwasherJobState,spin).
valueOf(dishwasherJobState,unknown).
valueOf(dishwasherJobState,wash).
valueOf(dishwasherJobState,wrinklePrevent).

capability(doorControl).
attributeCommandOf(doorControl,door).
attributeCommandOf(doorControl,close).
attributeCommandOf(doorControl,open).
valueOf(door,closed).
valueOf(door,closing).
valueOf(door,open).
valueOf(door,opening).
valueOf(door,unknown).

capability(dryerMode).
attributeCommandOf(dryerMode,dryerMode).
attributeCommandOf(dryerMode,setDryerMode).
valueOf(dryerMode,regular).
valueOf(dryerMode,lowHeat).
valueOf(dryerMode,highHeat).

capability(dryerOperatingState).
attributeCommandOf(dryerOperatingState,machineState).
attributeCommandOf(dryerOperatingState,supportedMachineStates).
attributeCommandOf(dryerOperatingState,dryerJobState).
attributeCommandOf(dryerOperatingState,completionTime).
attributeCommandOf(dryerOperatingState,setMachineState).
valueOf(machineState,pause).
valueOf(machineState,run).
valueOf(machineState,stop).
valueOf(dryerJobState,cooling).
valueOf(dryerJobState,delayWash).
valueOf(dryerJobState,drying).
valueOf(dryerJobState,finished).
valueOf(dryerJobState,none).
valueOf(dryerJobState,weightSensing).
valueOf(dryerJobState,wrinklePrevent).

capability(dustSensor).
attributeCommandOf(dustSensor,fineDustLevel).
attributeCommandOf(dustSensor,dustLevel).

capability(energyMeter).
attributeCommandOf(energyMeter,energy).

capability(estimatedTimeOfArrival).
attributeCommandOf(estimatedTimeOfArrival,eta).

capability(execute).
attributeCommandOf(execute,data).
attributeCommandOf(execute,execute).

capability(fanSpeed).
attributeCommandOf(fanSpeed,fanSpeed).
attributeCommandOf(fanSpeed,setFanSpeed).

capability(filterStatus).
attributeCommandOf(filterStatus,filterStatus).
valueOf(filterStatus,normal).
valueOf(filterStatus,replace).

capability(garageDoorControl).
attributeCommandOf(garageDoorControl,door).
attributeCommandOf(garageDoorControl,close).
attributeCommandOf(garageDoorControl,open).
valueOf(door,closed).
valueOf(door,closing).
valueOf(door,open).
valueOf(door,opening).
valueOf(door,unknown).

capability(geolocation).
attributeCommandOf(geolocation,latitude).
attributeCommandOf(geolocation,longitude).
attributeCommandOf(geolocation,method).
attributeCommandOf(geolocation,accuracy).
attributeCommandOf(geolocation,altitudeAccuracy).
attributeCommandOf(geolocation,heading).
attributeCommandOf(geolocation,speed).
attributeCommandOf(geolocation,lastUpdateTime).

capability(holdableButton).
attributeCommandOf(holdableButton,button).
attributeCommandOf(holdableButton,numberOfButtons).
valueOf(button,held).
valueOf(button,pushed).

capability(illuminanceMeasurement).
attributeCommandOf(illuminanceMeasurement,illuminance).

capability(imageCapture).
attributeCommandOf(imageCapture,image).
attributeCommandOf(imageCapture,take).

capability(indicator).
attributeCommandOf(indicator,indicatorStatus).
attributeCommandOf(indicator,indicatorNever).
attributeCommandOf(indicator,indicatorWhenOff).
attributeCommandOf(indicator,indicatorWhenOn).
valueOf(indicatorStatus,never).
valueOf(indicatorStatus,whenoff).
valueOf(indicatorStatus,whenon).

capability(infraredLevel).
attributeCommandOf(infraredLevel,infraredLevel).
attributeCommandOf(infraredLevel,setInfraredLevel).

capability(light).
attributeCommandOf(light,switch).
attributeCommandOf(light,off).
attributeCommandOf(light,on).
valueOf(switch,off).
valueOf(switch,on).

capability(lockOnly).
attributeCommandOf(lockOnly,lock).
valueOf(lock,locked).
valueOf(lock,unknown).
valueOf(lock,unlocked).
valueOf(lock,unlockedwithtimeout).

capability(lock).
attributeCommandOf(lock,lock).
attributeCommandOf(lock,unlock).
valueOf(lock,locked).
valueOf(lock,unknown).
valueOf(lock,unlocked).
valueOf(lock,unlockedwithtimeout).

capability(mediaController).
attributeCommandOf(mediaController,activities).
attributeCommandOf(mediaController,currentActivity).
attributeCommandOf(mediaController,startActivity).

capability(mediaInputSource).
attributeCommandOf(mediaInputSource,inputSource).
attributeCommandOf(mediaInputSource,supportedInputSources).
attributeCommandOf(mediaInputSource,setInputSource).
valueOf(inputSource,am).
valueOf(inputSource,cd).
valueOf(inputSource,fm).
valueOf(inputSource,hdmi).
valueOf(inputSource,hdmi2).
valueOf(inputSource,usb).
valueOf(inputSource,youtube).
valueOf(inputSource,aux).
valueOf(inputSource,bluetooth).
valueOf(inputSource,digital).
valueOf(inputSource,melon).
valueOf(inputSource,wifi).

capability(mediaPlaybackRepeat).
attributeCommandOf(mediaPlaybackRepeat,playbackRepeatMode).
attributeCommandOf(mediaPlaybackRepeat,setPlaybackRepeatMode).
valueOf(playbackRepeatMode,all).
valueOf(playbackRepeatMode,off).
valueOf(playbackRepeatMode,one).

capability(mediaPlaybackShuffle).
attributeCommandOf(mediaPlaybackShuffle,playbackShuffle).
attributeCommandOf(mediaPlaybackShuffle,setPlaybackShuffle).
valueOf(playbackShuffle,disabled).
valueOf(playbackShuffle,enabled).

capability(mediaPlayback).
attributeCommandOf(mediaPlayback,level).
attributeCommandOf(mediaPlayback,playbackStatus).
attributeCommandOf(mediaPlayback,setPlaybackStatus).
attributeCommandOf(mediaPlayback,play).
attributeCommandOf(mediaPlayback,pause).
attributeCommandOf(mediaPlayback,stop).
valueOf(playbackStatus,pause).
valueOf(playbackStatus,play).
valueOf(playbackStatus,stop).

capability(mediaPresets).
attributeCommandOf(mediaPresets,presets).
attributeCommandOf(mediaPresets,selectPreset).
attributeCommandOf(mediaPresets,playPreset).

capability(mediaTrackControl).
attributeCommandOf(mediaTrackControl,nextTrack).
attributeCommandOf(mediaTrackControl,previousTrack).

capability(momentary).
attributeCommandOf(momentary,push).

capability(motionSensor).
attributeCommandOf(motionSensor,motion).
valueOf(motion,active).
valueOf(motion,inactive).

capability(musicPlayer).
attributeCommandOf(musicPlayer,level).
attributeCommandOf(musicPlayer,mute).
attributeCommandOf(musicPlayer,status).
attributeCommandOf(musicPlayer,trackData).
attributeCommandOf(musicPlayer,trackDescription).
attributeCommandOf(musicPlayer,nextTrack).
attributeCommandOf(musicPlayer,pause).
attributeCommandOf(musicPlayer,play).
attributeCommandOf(musicPlayer,playTrack).
attributeCommandOf(musicPlayer,previousTrack).
attributeCommandOf(musicPlayer,restoreTrack).
attributeCommandOf(musicPlayer,resumeTrack).
attributeCommandOf(musicPlayer,setLevel).
attributeCommandOf(musicPlayer,setTrack).
attributeCommandOf(musicPlayer,stop).
attributeCommandOf(musicPlayer,unmute).
valueOf(mute,muted).
valueOf(mute,unmuted).

capability(notification).
attributeCommandOf(notification,deviceNotification).

capability(odorSensor).
attributeCommandOf(odorSensor,odorLevel).

capability(outlet).
attributeCommandOf(outlet,switch).
valueOf(switch,off).
valueOf(switch,on).

capability(ovenMode).
attributeCommandOf(ovenMode,ovenMode).
attributeCommandOf(ovenMode,setOvenMode).
valueOf(ovenMode,heating).
valueOf(ovenMode,grill).
valueOf(ovenMode,warming).
valueOf(ovenMode,defrosting).

capability(ovenOperatingState).
attributeCommandOf(ovenOperatingState,machineState).
attributeCommandOf(ovenOperatingState,supportedMachineStates).
attributeCommandOf(ovenOperatingState,ovenJobState).
attributeCommandOf(ovenOperatingState,completionTime).
attributeCommandOf(ovenOperatingState,operationTime).
attributeCommandOf(ovenOperatingState,progress).
attributeCommandOf(ovenOperatingState,setMachineState).
valueOf(machineState,ready).
valueOf(machineState,running).
valueOf(machineState,paused).
valueOf(ovenJobState,cleaning).
valueOf(ovenJobState,cooking).
valueOf(ovenJobState,cooling).
valueOf(ovenJobState,draining).
valueOf(ovenJobState,preheat).
valueOf(ovenJobState,ready).
valueOf(ovenJobState,rinsing).

capability(ovenSetpoint).
attributeCommandOf(ovenSetpoint,ovenSetpoint).
attributeCommandOf(ovenSetpoint,setOvenSetpoint).

capability(pHMeasurement).
attributeCommandOf(pHMeasurement,pH).

capability(polling).
attributeCommandOf(polling,poll).

capability(powerConsumptionReport).
attributeCommandOf(powerConsumptionReport,powerConsumption).

capability(powerMeter).
attributeCommandOf(powerMeter,power).

capability(powerSource).
attributeCommandOf(powerSource,powerSource).
valueOf(powerSource,battery).
valueOf(powerSource,dc).
valueOf(powerSource,mains).
valueOf(powerSource,unknown).

capability(presenceSensor).
attributeCommandOf(presenceSensor,presence).
valueOf(presence,notpresent).
valueOf(presence,present).

capability(rapidCooling).
attributeCommandOf(rapidCooling,rapidCooling).
attributeCommandOf(rapidCooling,setRapidCooling).
valueOf(rapidCooling,off).
valueOf(rapidCooling,on).

capability(refresh).
attributeCommandOf(refresh,refresh).

capability(refrigerationSetpoint).
attributeCommandOf(refrigerationSetpoint,refrigerationSetpoint).
attributeCommandOf(refrigerationSetpoint,setRefrigerationSetpoint).

capability(relativeHumidityMeasurement).
attributeCommandOf(relativeHumidityMeasurement,humidity).

capability(relaySwitch).
attributeCommandOf(relaySwitch,switch).
attributeCommandOf(relaySwitch,off).
attributeCommandOf(relaySwitch,on).
valueOf(switch,off).
valueOf(switch,on).

capability(robotCleanerCleaningMode).
attributeCommandOf(robotCleanerCleaningMode,robotCleanerCleaningMode).
attributeCommandOf(robotCleanerCleaningMode,setRobotCleanerCleaningMode).
valueOf(robotCleanerCleaningMode,auto).
valueOf(robotCleanerCleaningMode,part).
valueOf(robotCleanerCleaningMode,repeat).
valueOf(robotCleanerCleaningMode,manual).
valueOf(robotCleanerCleaningMode,stop).
valueOf(robotCleanerCleaningMode,map).

capability(robotCleanerMovement).
attributeCommandOf(robotCleanerMovement,robotCleanerMovement).
attributeCommandOf(robotCleanerMovement,setRobotCleanerMovement).
valueOf(robotCleanerMovement,homing).
valueOf(robotCleanerMovement,idle).
valueOf(robotCleanerMovement,charging).
valueOf(robotCleanerMovement,alarm).
valueOf(robotCleanerMovement,powerOff).
valueOf(robotCleanerMovement,reserve).
valueOf(robotCleanerMovement,point).
valueOf(robotCleanerMovement,after).
valueOf(robotCleanerMovement,cleaning).

capability(robotCleanerTurboMode).
attributeCommandOf(robotCleanerTurboMode,robotCleanerTurboMode).
attributeCommandOf(robotCleanerTurboMode,setRobotCleanerTurboMode).
valueOf(robotCleanerTurboMode,on).
valueOf(robotCleanerTurboMode,off).
valueOf(robotCleanerTurboMode,silence).

capability(sensor).

capability(shockSensor).
attributeCommandOf(shockSensor,shock).
valueOf(shock,clear).
valueOf(shock,detected).

capability(signalStrength).
attributeCommandOf(signalStrength,lqi).
attributeCommandOf(signalStrength,rssi).

capability(sleepSensor).
attributeCommandOf(sleepSensor,sleeping).
valueOf(sleeping,notsleeping).
valueOf(sleeping,sleeping).

capability(smokeDetector).
attributeCommandOf(smokeDetector,smoke).
valueOf(smoke,clear).
valueOf(smoke,detected).
valueOf(smoke,tested).

capability(soundPressureLevel).
attributeCommandOf(soundPressureLevel,soundPressureLevel).

capability(soundSensor).
attributeCommandOf(soundSensor,sound).
valueOf(sound,detected).
valueOf(sound,notdetected).

capability(speechRecognition).
attributeCommandOf(speechRecognition,phraseSpoken).

capability(speechSynthesis).
attributeCommandOf(speechSynthesis,speak).

capability(stepSensor).
attributeCommandOf(stepSensor,goal).
attributeCommandOf(stepSensor,steps).

capability(switchLevel).
attributeCommandOf(switchLevel,level).
attributeCommandOf(switchLevel,setLevel).

capability(switch).
attributeCommandOf(switch,switch).
attributeCommandOf(switch,off).
attributeCommandOf(switch,on).
valueOf(switch,off).
valueOf(switch,on).

capability(tamperAlert).
attributeCommandOf(tamperAlert,tamper).
valueOf(tamper,clear).
valueOf(tamper,detected).

capability(temperatureMeasurement).
attributeCommandOf(temperatureMeasurement,temperature).

capability(thermostatCoolingSetpoint).
attributeCommandOf(thermostatCoolingSetpoint,coolingSetpoint).
attributeCommandOf(thermostatCoolingSetpoint,setCoolingSetpoint).

capability(thermostatFanMode).
attributeCommandOf(thermostatFanMode,thermostatFanMode).
attributeCommandOf(thermostatFanMode,supportedThermostatFanModes).
attributeCommandOf(thermostatFanMode,fanAuto).
attributeCommandOf(thermostatFanMode,fanCirculate).
attributeCommandOf(thermostatFanMode,fanOn).
attributeCommandOf(thermostatFanMode,setThermostatFanMode).
valueOf(thermostatFanMode,auto).
valueOf(thermostatFanMode,circulate).
valueOf(thermostatFanMode,followschedule).
valueOf(thermostatFanMode,on).

capability(thermostatHeatingSetpoint).
attributeCommandOf(thermostatHeatingSetpoint,heatingSetpoint).
attributeCommandOf(thermostatHeatingSetpoint,setHeatingSetpoint).

capability(thermostatMode).
attributeCommandOf(thermostatMode,thermostatMode).
attributeCommandOf(thermostatMode,supportedThermostatModes).
attributeCommandOf(thermostatMode,auto).
attributeCommandOf(thermostatMode,cool).
attributeCommandOf(thermostatMode,emergencyHeat).
attributeCommandOf(thermostatMode,heat).
attributeCommandOf(thermostatMode,off).
attributeCommandOf(thermostatMode,setThermostatMode).
valueOf(thermostatMode,auto).
valueOf(thermostatMode,eco).
valueOf(thermostatMode,rushhour).
valueOf(thermostatMode,cool).
valueOf(thermostatMode,emergencyheat).
valueOf(thermostatMode,heat).
valueOf(thermostatMode,off).

capability(thermostatOperatingState).
attributeCommandOf(thermostatOperatingState,thermostatOperatingState).
valueOf(thermostatOperatingState,cooling).
valueOf(thermostatOperatingState,fanonly).
valueOf(thermostatOperatingState,heating).
valueOf(thermostatOperatingState,idle).
valueOf(thermostatOperatingState,pendingcool).
valueOf(thermostatOperatingState,pendingheat).
valueOf(thermostatOperatingState,venteconomizer).

capability(thermostatSetpoint).
attributeCommandOf(thermostatSetpoint,thermostatSetpoint).

capability(thermostat).
attributeCommandOf(thermostat,coolingSetpoint).
attributeCommandOf(thermostat,coolingSetpointRange).
attributeCommandOf(thermostat,heatingSetpoint).
attributeCommandOf(thermostat,heatingSetpointRange).
attributeCommandOf(thermostat,schedule).
attributeCommandOf(thermostat,temperature).
attributeCommandOf(thermostat,thermostatFanMode).
attributeCommandOf(thermostat,supportedThermostatFanModes).
attributeCommandOf(thermostat,thermostatMode).
attributeCommandOf(thermostat,supportedThermostatModes).
attributeCommandOf(thermostat,thermostatOperatingState).
attributeCommandOf(thermostat,thermostatSetpoint).
attributeCommandOf(thermostat,thermostatSetpointRange).
attributeCommandOf(thermostat,auto).
attributeCommandOf(thermostat,cool).
attributeCommandOf(thermostat,emergencyHeat).
attributeCommandOf(thermostat,fanAuto).
attributeCommandOf(thermostat,fanCirculate).
attributeCommandOf(thermostat,fanOn).
attributeCommandOf(thermostat,heat).
attributeCommandOf(thermostat,off).
attributeCommandOf(thermostat,setCoolingSetpoint).
attributeCommandOf(thermostat,setHeatingSetpoint).
attributeCommandOf(thermostat,setSchedule).
attributeCommandOf(thermostat,setThermostatFanMode).
attributeCommandOf(thermostat,setThermostatMode).
valueOf(thermostatFanMode,auto).
valueOf(thermostatFanMode,circulate).
valueOf(thermostatFanMode,followschedule).
valueOf(thermostatFanMode,on).
valueOf(thermostatMode,auto).
valueOf(thermostatMode,eco).
valueOf(thermostatMode,rushhour).
valueOf(thermostatMode,cool).
valueOf(thermostatMode,emergencyheat).
valueOf(thermostatMode,heat).
valueOf(thermostatMode,off).
valueOf(thermostatOperatingState,cooling).
valueOf(thermostatOperatingState,fanonly).
valueOf(thermostatOperatingState,heating).
valueOf(thermostatOperatingState,idle).
valueOf(thermostatOperatingState,pendingcool).
valueOf(thermostatOperatingState,pendingheat).
valueOf(thermostatOperatingState,venteconomizer).

capability(threeAxis).
attributeCommandOf(threeAxis,threeAxis).

capability(timedSession).
attributeCommandOf(timedSession,sessionStatus).
attributeCommandOf(timedSession,completionTime).
attributeCommandOf(timedSession,cancel).
attributeCommandOf(timedSession,pause).
attributeCommandOf(timedSession,setCompletionTime).
attributeCommandOf(timedSession,start).
attributeCommandOf(timedSession,stop).
valueOf(sessionStatus,canceled).
valueOf(sessionStatus,paused).
valueOf(sessionStatus,running).
valueOf(sessionStatus,stopped).

capability(tone).
attributeCommandOf(tone,beep).

capability(touchSensor).
attributeCommandOf(touchSensor,touch).
valueOf(touch,touched).

capability(tvChannel).
attributeCommandOf(tvChannel,tvChannel).
attributeCommandOf(tvChannel,setTvChannel).
attributeCommandOf(tvChannel,channelUp).
attributeCommandOf(tvChannel,channelDown).

capability(ultravioletIndex).
attributeCommandOf(ultravioletIndex,ultravioletIndex).

capability(valve).
attributeCommandOf(valve,valve).
attributeCommandOf(valve,close).
attributeCommandOf(valve,open).
valueOf(valve,closed).
valueOf(valve,open).

capability(videoClips).
attributeCommandOf(videoClips,videoClip).
attributeCommandOf(videoClips,captureClip).

capability(videoStream).
attributeCommandOf(videoStream,stream).
attributeCommandOf(videoStream,startStream).
attributeCommandOf(videoStream,stopStream).

capability(voltageMeasurement).
attributeCommandOf(voltageMeasurement,voltage).

capability(washerMode).
attributeCommandOf(washerMode,washerMode).
attributeCommandOf(washerMode,setWasherMode).
valueOf(washerMode,regular).
valueOf(washerMode,heavy).
valueOf(washerMode,rinse).
valueOf(washerMode,spinDry).

capability(washerOperatingState).
attributeCommandOf(washerOperatingState,machineState).
attributeCommandOf(washerOperatingState,supportedMachineStates).
attributeCommandOf(washerOperatingState,washerJobState).
attributeCommandOf(washerOperatingState,completionTime).
attributeCommandOf(washerOperatingState,setMachineState).
valueOf(machineState,pause).
valueOf(machineState,run).
valueOf(machineState,stop).
valueOf(washerJobState,airWash).
valueOf(washerJobState,cooling).
valueOf(washerJobState,delayWash).
valueOf(washerJobState,drying).
valueOf(washerJobState,finish).
valueOf(washerJobState,none).
valueOf(washerJobState,preWash).
valueOf(washerJobState,rinse).
valueOf(washerJobState,spin).
valueOf(washerJobState,wash).
valueOf(washerJobState,weightSensing).
valueOf(washerJobState,wrinklePrevent).

capability(waterSensor).
attributeCommandOf(waterSensor,water).
valueOf(water,dry).
valueOf(water,wet).

capability(windowShade).
attributeCommandOf(windowShade,windowShade).
attributeCommandOf(windowShade,close).
attributeCommandOf(windowShade,open).
attributeCommandOf(windowShade,presetPosition).
valueOf(windowShade,closed).
valueOf(windowShade,closing).
valueOf(windowShade,open).
valueOf(windowShade,opening).
valueOf(windowShade,partiallyopen).
valueOf(windowShade,unknown).