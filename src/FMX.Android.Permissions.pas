unit FMX.Android.Permissions;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.UITypes, System.DateUtils, System.Generics.Collections,
  FMX.Utils, FMX.Types, FMX.Controls, FMX.Objects, FMX.StdCtrls, FMX.Graphics, FMX.MultiResBitmap, FMX.Dialogs,
  FMX.Ani, FMX.Effects, System.Actions, FMX.ActnList, FMX.Layouts, FMX.Filter.Effects, FMX.DialogService,
 {$IF DEFINED(VER330) OR DEFINED(VER340)}
  System.Permissions,
 {$IFDEF ANDROID}
  FMX.Platform.Android,
  FMX.Helpers.Android,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Net,
  Androidapi.JNI.Os,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNIBridge,
  Androidapi.Helpers,
  {$ENDIF} {$ENDIF}
  TypInfo;

Type

    TAndroidPermissionsNames = Class(TPersistent)
       Private
          fSEND_SMS: Boolean;
          fCAPTURE_AUDIO_OUTPUT: Boolean;
          fWRITE_VOICEMAIL: Boolean;
          fWRITE_SECURE_SETTINGS: Boolean;
          fSET_TIME_ZONE: Boolean;
          fREAD_SYNC_SETTINGS: Boolean;
          fMODIFY_AUDIO_SETTINGS: Boolean;
          fKILL_BACKGROUND_PROCESSES: Boolean;
          fGET_TASKS: Boolean;
          fDELETE_CACHE_FILES: Boolean;
          fCAPTURE_VIDEO_OUTPUT: Boolean;
          fBIND_NOTIFICATION_LISTENER_SERVICE: Boolean;
          fUPDATE_DEVICE_STATS: Boolean;
          fREAD_CONTACTS: Boolean;
          fBIND_TELECOM_CONNECTION_SERVICE: Boolean;
          fBIND_PRINT_SERVICE: Boolean;
          fRECORD_AUDIO: Boolean;
          fREAD_FRAME_BUFFER: Boolean;
          fMOUNT_UNMOUNT_FILESYSTEMS: Boolean;
          fPACKAGE_USAGE_STATS: Boolean;
          fGET_PACKAGE_SIZE: Boolean;
          fBROADCAST_STICKY: Boolean;
          fWRITE_SYNC_SETTINGS: Boolean;
          fREAD_SMS: Boolean;
          fREAD_CALENDAR: Boolean;
          fCONTROL_LOCATION_UPDATES: Boolean;
          fBIND_REMOTEVIEWS: Boolean;
          fADD_VOICEMAIL: Boolean;
          fWRITE_CONTACTS: Boolean;
          fREAD_INPUT_STATE: Boolean;
          fCHANGE_NETWORK_STATE: Boolean;
          fCAPTURE_SECURE_VIDEO_OUTPUT: Boolean;
          fCAMERA: Boolean;
          fBIND_NFC_SERVICE: Boolean;
          fWRITE_GSERVICES: Boolean;
          fSET_WALLPAPER: Boolean;
          fREQUEST_DELETE_PACKAGES: Boolean;
          fBIND_VPN_SERVICE: Boolean;
          fBIND_CHOOSER_TARGET_SERVICE: Boolean;
          fINSTALL_PACKAGES: Boolean;
          fCLEAR_APP_CACHE: Boolean;
          fBIND_VR_LISTENER_SERVICE: Boolean;
          fACCESS_NOTIFICATION_POLICY: Boolean;
          fWRITE_CALENDAR: Boolean;
          fSET_TIME: Boolean;
          fDUMP: Boolean;
          fBROADCAST_SMS: Boolean;
          fBIND_TEXT_SERVICE: Boolean;
          fBIND_MIDI_DEVICE_SERVICE: Boolean;
          fBIND_ACCESSIBILITY_SERVICE: Boolean;
          fBATTERY_STATS: Boolean;
          fUSE_SIP: Boolean;
          fUSE_FINGERPRINT: Boolean;
          fUSE_BIOMETRIC: Boolean;
          fTRANSMIT_IR: Boolean;
          fSEND_RESPOND_VIA_MESSAGE: Boolean;
          fREAD_EXTERNAL_STORAGE: Boolean;
          fDIAGNOSTIC: Boolean;
          fBIND_APPWIDGET: Boolean;
          fPERSISTENT_ACTIVITY: Boolean;
          fBIND_CONDITION_PROVIDER_SERVICE: Boolean;
          fSET_ANIMATION_SCALE: Boolean;
          fSET_ALARM: Boolean;
          fREAD_SYNC_STATS: Boolean;
          fCHANGE_WIFI_STATE: Boolean;
          fSTATUS_BAR: Boolean;
          fMOUNT_FORMAT_FILESYSTEMS: Boolean;
          fMANAGE_DOCUMENTS: Boolean;
          fWRITE_EXTERNAL_STORAGE: Boolean;
          fLOCATION_HARDWARE: Boolean;
          fGLOBAL_SEARCH: Boolean;
          fACCESS_NETWORK_STATE: Boolean;
          fVIBRATE: Boolean;
          fRECEIVE_SMS: Boolean;
          fRECEIVE_BOOT_COMPLETED: Boolean;
          fCHANGE_WIFI_MULTICAST_STATE: Boolean;
          fBIND_CARRIER_SERVICES: Boolean;
          fSET_PROCESS_LIMIT: Boolean;
          fREBOOT: Boolean;
          fCHANGE_CONFIGURATION: Boolean;
          fBLUETOOTH_ADMIN: Boolean;
          fBIND_DEVICE_ADMIN: Boolean;
          fBIND_AUTOFILL_SERVICE: Boolean;
          fANSWER_PHONE_CALLS: Boolean;
          fBODY_SENSORS: Boolean;
          fBIND_TV_INPUT: Boolean;
          fBIND_QUICK_SETTINGS_TILE: Boolean;
          fBIND_INCALL_SERVICE: Boolean;
          fSET_DEBUG_APP: Boolean;
          fRESTART_PACKAGES: Boolean;
          fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS: Boolean;
          fBIND_DREAM_SERVICE: Boolean;
          fEXPAND_STATUS_BAR: Boolean;
          fDELETE_PACKAGES: Boolean;
          fACCESS_COARSE_LOCATION: Boolean;
          fSET_ALWAYS_FINISH: Boolean;
          fREAD_CALL_LOG: Boolean;
          fINTERNET: Boolean;
          fINSTANT_APP_FOREGROUND_SERVICE: Boolean;
          fBIND_VISUAL_VOICEMAIL_SERVICE: Boolean;
          fACCESS_WIFI_STATE: Boolean;
          fPROCESS_OUTGOING_CALLS: Boolean;
          fNFC: Boolean;
          fMANAGE_OWN_CALLS: Boolean;
          fINSTALL_SHORTCUT: Boolean;
          fWRITE_APN_SETTINGS: Boolean;
          fUNINSTALL_SHORTCUT: Boolean;
          fSET_WALLPAPER_HINTS: Boolean;
          fMODIFY_PHONE_STATE: Boolean;
          fDISABLE_KEYGUARD: Boolean;
          fBROADCAST_WAP_PUSH: Boolean;
          fBIND_VOICE_INTERACTION: Boolean;
          fBIND_CARRIER_MESSAGING_SERVICE: Boolean;
          fCHANGE_COMPONENT_ENABLED_STATE: Boolean;
          fBLUETOOTH_PRIVILEGED: Boolean;
          fBIND_SCREENING_SERVICE: Boolean;
          fWRITE_CALL_LOG: Boolean;
          fWAKE_LOCK: Boolean;
          fCALL_PRIVILEGED: Boolean;
          fSYSTEM_ALERT_WINDOW: Boolean;
          fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND: Boolean;
          fMASTER_CLEAR: Boolean;
          fINSTALL_LOCATION_PROVIDER: Boolean;
          fSIGNAL_PERSISTENT_PROCESSES: Boolean;
          fMEDIA_CONTENT_CONTROL: Boolean;
          fFACTORY_TEST: Boolean;
          fBLUETOOTH: Boolean;
          fACCESS_CHECKIN_PROPERTIES: Boolean;
          fREQUEST_COMPANION_RUN_IN_BACKGROUND: Boolean;
          fGET_ACCOUNTS_PRIVILEGED: Boolean;
          fBROADCAST_PACKAGE_REMOVED: Boolean;
          fACCESS_LOCATION_EXTRA_COMMANDS: Boolean;
          fWRITE_SETTINGS: Boolean;
          fREQUEST_INSTALL_PACKAGES: Boolean;
          fREORDER_TASKS: Boolean;
          fRECEIVE_WAP_PUSH: Boolean;
          fREAD_PHONE_STATE: Boolean;
          fREAD_LOGS: Boolean;
          fBIND_INPUT_METHOD: Boolean;
          fSET_PREFERRED_APPLICATIONS: Boolean;
          fRECEIVE_MMS: Boolean;
          fREAD_VOICEMAIL: Boolean;
          fREAD_PHONE_NUMBERS: Boolean;
          fBIND_WALLPAPER: Boolean;
          fACCOUNT_MANAGER: Boolean;
          fGET_ACCOUNTS: Boolean;
          fCALL_PHONE: Boolean;
          fACCESS_FINE_LOCATION: Boolean;
       Published
          Property ACCESS_CHECKIN_PROPERTIES : Boolean Read fACCESS_CHECKIN_PROPERTIES Write fACCESS_CHECKIN_PROPERTIES;
          Property ACCESS_COARSE_LOCATION : Boolean Read fACCESS_COARSE_LOCATION Write fACCESS_COARSE_LOCATION;
          Property ACCESS_FINE_LOCATION : Boolean Read fACCESS_FINE_LOCATION Write fACCESS_FINE_LOCATION;
          Property ACCESS_LOCATION_EXTRA_COMMANDS : Boolean Read fACCESS_LOCATION_EXTRA_COMMANDS Write fACCESS_LOCATION_EXTRA_COMMANDS;
          Property ACCESS_NETWORK_STATE : Boolean Read fACCESS_NETWORK_STATE Write fACCESS_NETWORK_STATE;
          Property ACCESS_NOTIFICATION_POLICY : Boolean Read fACCESS_NOTIFICATION_POLICY Write fACCESS_NOTIFICATION_POLICY;
          Property ACCESS_WIFI_STATE : Boolean Read fACCESS_WIFI_STATE Write fACCESS_WIFI_STATE;
          Property ACCOUNT_MANAGER : Boolean Read fACCOUNT_MANAGER Write fACCOUNT_MANAGER;
          Property ADD_VOICEMAIL : Boolean Read fADD_VOICEMAIL Write fADD_VOICEMAIL;
          Property ANSWER_PHONE_CALLS : Boolean Read fANSWER_PHONE_CALLS Write fANSWER_PHONE_CALLS;
          Property BATTERY_STATS : Boolean Read fBATTERY_STATS Write fBATTERY_STATS;
          Property BIND_ACCESSIBILITY_SERVICE : Boolean Read fBIND_ACCESSIBILITY_SERVICE Write fBIND_ACCESSIBILITY_SERVICE;
          Property BIND_APPWIDGET : Boolean Read fBIND_APPWIDGET Write fBIND_APPWIDGET;
          Property BIND_AUTOFILL_SERVICE : Boolean Read fBIND_AUTOFILL_SERVICE Write fBIND_AUTOFILL_SERVICE;
          Property BIND_CARRIER_MESSAGING_SERVICE : Boolean Read fBIND_CARRIER_MESSAGING_SERVICE Write fBIND_CARRIER_MESSAGING_SERVICE;
          Property BIND_CARRIER_SERVICES : Boolean Read fBIND_CARRIER_SERVICES Write fBIND_CARRIER_SERVICES;
          Property BIND_CHOOSER_TARGET_SERVICE : Boolean Read fBIND_CHOOSER_TARGET_SERVICE Write fBIND_CHOOSER_TARGET_SERVICE;
          Property BIND_CONDITION_PROVIDER_SERVICE : Boolean Read fBIND_CONDITION_PROVIDER_SERVICE Write fBIND_CONDITION_PROVIDER_SERVICE;
          Property BIND_DEVICE_ADMIN : Boolean Read fBIND_DEVICE_ADMIN Write fBIND_DEVICE_ADMIN;
          Property BIND_DREAM_SERVICE : Boolean Read fBIND_DREAM_SERVICE Write fBIND_DREAM_SERVICE;
          Property BIND_INCALL_SERVICE : Boolean Read fBIND_INCALL_SERVICE Write fBIND_INCALL_SERVICE;
          Property BIND_INPUT_METHOD : Boolean Read fBIND_INPUT_METHOD Write fBIND_INPUT_METHOD;
          Property BIND_MIDI_DEVICE_SERVICE : Boolean Read fBIND_MIDI_DEVICE_SERVICE Write fBIND_MIDI_DEVICE_SERVICE;
          Property BIND_NFC_SERVICE : Boolean Read fBIND_NFC_SERVICE Write fBIND_NFC_SERVICE;
          Property BIND_NOTIFICATION_LISTENER_SERVICE : Boolean Read fBIND_NOTIFICATION_LISTENER_SERVICE Write fBIND_NOTIFICATION_LISTENER_SERVICE;
          Property BIND_PRINT_SERVICE : Boolean Read fBIND_PRINT_SERVICE Write fBIND_PRINT_SERVICE;
          Property BIND_QUICK_SETTINGS_TILE : Boolean Read fBIND_QUICK_SETTINGS_TILE Write fBIND_QUICK_SETTINGS_TILE;
          Property BIND_REMOTEVIEWS : Boolean Read fBIND_REMOTEVIEWS Write fBIND_REMOTEVIEWS;
          Property BIND_SCREENING_SERVICE : Boolean Read fBIND_SCREENING_SERVICE Write fBIND_SCREENING_SERVICE;
          Property BIND_TELECOM_CONNECTION_SERVICE : Boolean Read fBIND_TELECOM_CONNECTION_SERVICE Write fBIND_TELECOM_CONNECTION_SERVICE;
          Property BIND_TEXT_SERVICE : Boolean Read fBIND_TEXT_SERVICE Write fBIND_TEXT_SERVICE;
          Property BIND_TV_INPUT : Boolean Read fBIND_TV_INPUT Write fBIND_TV_INPUT;
          Property BIND_VISUAL_VOICEMAIL_SERVICE : Boolean Read fBIND_VISUAL_VOICEMAIL_SERVICE Write fBIND_VISUAL_VOICEMAIL_SERVICE;
          Property BIND_VOICE_INTERACTION : Boolean Read fBIND_VOICE_INTERACTION Write fBIND_VOICE_INTERACTION;
          Property BIND_VPN_SERVICE : Boolean Read fBIND_VPN_SERVICE Write fBIND_VPN_SERVICE;
          Property BIND_VR_LISTENER_SERVICE : Boolean Read fBIND_VR_LISTENER_SERVICE Write fBIND_VR_LISTENER_SERVICE;
          Property BIND_WALLPAPER : Boolean Read fBIND_WALLPAPER Write fBIND_WALLPAPER;
          Property BLUETOOTH : Boolean Read fBLUETOOTH Write fBLUETOOTH;
          Property BLUETOOTH_ADMIN : Boolean Read fBLUETOOTH_ADMIN Write fBLUETOOTH_ADMIN;
          Property BLUETOOTH_PRIVILEGED : Boolean Read fBLUETOOTH_PRIVILEGED Write fBLUETOOTH_PRIVILEGED;
          Property BODY_SENSORS : Boolean Read fBODY_SENSORS Write fBODY_SENSORS;
          Property BROADCAST_PACKAGE_REMOVED : Boolean Read fBROADCAST_PACKAGE_REMOVED Write fBROADCAST_PACKAGE_REMOVED;
          Property BROADCAST_SMS : Boolean Read fBROADCAST_SMS Write fBROADCAST_SMS;
          Property BROADCAST_STICKY : Boolean Read fBROADCAST_STICKY Write fBROADCAST_STICKY;
          Property BROADCAST_WAP_PUSH : Boolean Read fBROADCAST_WAP_PUSH Write fBROADCAST_WAP_PUSH;
          Property CALL_PHONE : Boolean Read fCALL_PHONE Write fCALL_PHONE;
          Property CALL_PRIVILEGED : Boolean Read fCALL_PRIVILEGED Write fCALL_PRIVILEGED;
          Property CAMERA : Boolean Read fCAMERA Write fCAMERA;
          Property CAPTURE_AUDIO_OUTPUT : Boolean Read fCAPTURE_AUDIO_OUTPUT Write fCAPTURE_AUDIO_OUTPUT;
          Property CAPTURE_SECURE_VIDEO_OUTPUT : Boolean Read fCAPTURE_SECURE_VIDEO_OUTPUT Write fCAPTURE_SECURE_VIDEO_OUTPUT;
          Property CAPTURE_VIDEO_OUTPUT : Boolean Read fCAPTURE_VIDEO_OUTPUT Write fCAPTURE_VIDEO_OUTPUT;
          Property CHANGE_COMPONENT_ENABLED_STATE : Boolean Read fCHANGE_COMPONENT_ENABLED_STATE Write fCHANGE_COMPONENT_ENABLED_STATE;
          Property CHANGE_CONFIGURATION : Boolean Read fCHANGE_CONFIGURATION Write fCHANGE_CONFIGURATION;
          Property CHANGE_NETWORK_STATE : Boolean Read fCHANGE_NETWORK_STATE Write fCHANGE_NETWORK_STATE;
          Property CHANGE_WIFI_MULTICAST_STATE : Boolean Read fCHANGE_WIFI_MULTICAST_STATE Write fCHANGE_WIFI_MULTICAST_STATE;
          Property CHANGE_WIFI_STATE : Boolean Read fCHANGE_WIFI_STATE Write fCHANGE_WIFI_STATE;
          Property CLEAR_APP_CACHE : Boolean Read fCLEAR_APP_CACHE Write fCLEAR_APP_CACHE;
          Property CONTROL_LOCATION_UPDATES : Boolean Read fCONTROL_LOCATION_UPDATES Write fCONTROL_LOCATION_UPDATES;
          Property DELETE_CACHE_FILES : Boolean Read fDELETE_CACHE_FILES Write fDELETE_CACHE_FILES;
          Property DELETE_PACKAGES : Boolean Read fDELETE_PACKAGES Write fDELETE_PACKAGES;
          Property DIAGNOSTIC : Boolean Read fDIAGNOSTIC Write fDIAGNOSTIC;
          Property DISABLE_KEYGUARD : Boolean Read fDISABLE_KEYGUARD Write fDISABLE_KEYGUARD;
          Property DUMP : Boolean Read fDUMP Write fDUMP;
          Property EXPAND_STATUS_BAR : Boolean Read fEXPAND_STATUS_BAR Write fEXPAND_STATUS_BAR;
          Property FACTORY_TEST : Boolean Read fFACTORY_TEST Write fFACTORY_TEST;
          Property GET_ACCOUNTS : Boolean Read fGET_ACCOUNTS Write fGET_ACCOUNTS;
          Property GET_ACCOUNTS_PRIVILEGED : Boolean Read fGET_ACCOUNTS_PRIVILEGED Write fGET_ACCOUNTS_PRIVILEGED;
          Property GET_PACKAGE_SIZE : Boolean Read fGET_PACKAGE_SIZE Write fGET_PACKAGE_SIZE;
          Property GET_TASKS : Boolean Read fGET_TASKS Write fGET_TASKS;
          Property GLOBAL_SEARCH : Boolean Read fGLOBAL_SEARCH Write fGLOBAL_SEARCH;
          Property INSTALL_LOCATION_PROVIDER : Boolean Read fINSTALL_LOCATION_PROVIDER Write fINSTALL_LOCATION_PROVIDER;
          Property INSTALL_PACKAGES : Boolean Read fINSTALL_PACKAGES Write fINSTALL_PACKAGES;
          Property INSTALL_SHORTCUT : Boolean Read fINSTALL_SHORTCUT Write fINSTALL_SHORTCUT;
          Property INSTANT_APP_FOREGROUND_SERVICE : Boolean Read fINSTANT_APP_FOREGROUND_SERVICE Write fINSTANT_APP_FOREGROUND_SERVICE;
          Property INTERNET : Boolean Read fINTERNET Write fINTERNET;
          Property KILL_BACKGROUND_PROCESSES : Boolean Read fKILL_BACKGROUND_PROCESSES Write fKILL_BACKGROUND_PROCESSES;
          Property LOCATION_HARDWARE : Boolean Read fLOCATION_HARDWARE Write fLOCATION_HARDWARE;
          Property MANAGE_DOCUMENTS : Boolean Read fMANAGE_DOCUMENTS Write fMANAGE_DOCUMENTS;
          Property MANAGE_OWN_CALLS : Boolean Read fMANAGE_OWN_CALLS Write fMANAGE_OWN_CALLS;
          Property MASTER_CLEAR : Boolean Read fMASTER_CLEAR Write fMASTER_CLEAR;
          Property MEDIA_CONTENT_CONTROL : Boolean Read fMEDIA_CONTENT_CONTROL Write fMEDIA_CONTENT_CONTROL;
          Property MODIFY_AUDIO_SETTINGS : Boolean Read fMODIFY_AUDIO_SETTINGS Write fMODIFY_AUDIO_SETTINGS;
          Property MODIFY_PHONE_STATE : Boolean Read fMODIFY_PHONE_STATE Write fMODIFY_PHONE_STATE;
          Property MOUNT_FORMAT_FILESYSTEMS : Boolean Read fMOUNT_FORMAT_FILESYSTEMS Write fMOUNT_FORMAT_FILESYSTEMS;
          Property MOUNT_UNMOUNT_FILESYSTEMS : Boolean Read fMOUNT_UNMOUNT_FILESYSTEMS Write fMOUNT_UNMOUNT_FILESYSTEMS;
          Property NFC : Boolean Read fNFC Write fNFC;
          Property PACKAGE_USAGE_STATS : Boolean Read fPACKAGE_USAGE_STATS Write fPACKAGE_USAGE_STATS;
          Property PERSISTENT_ACTIVITY : Boolean Read fPERSISTENT_ACTIVITY Write fPERSISTENT_ACTIVITY;
          Property PROCESS_OUTGOING_CALLS : Boolean Read fPROCESS_OUTGOING_CALLS Write fPROCESS_OUTGOING_CALLS;
          Property READ_CALENDAR : Boolean Read fREAD_CALENDAR Write fREAD_CALENDAR;
          Property READ_CALL_LOG : Boolean Read fREAD_CALL_LOG Write fREAD_CALL_LOG;
          Property READ_CONTACTS : Boolean Read fREAD_CONTACTS Write fREAD_CONTACTS;
          Property READ_EXTERNAL_STORAGE : Boolean Read fREAD_EXTERNAL_STORAGE Write fREAD_EXTERNAL_STORAGE;
          Property READ_FRAME_BUFFER : Boolean Read fREAD_FRAME_BUFFER Write fREAD_FRAME_BUFFER;
          Property READ_INPUT_STATE : Boolean Read fREAD_INPUT_STATE Write fREAD_INPUT_STATE;
          Property READ_LOGS : Boolean Read fREAD_LOGS Write fREAD_LOGS;
          Property READ_PHONE_NUMBERS : Boolean Read fREAD_PHONE_NUMBERS Write fREAD_PHONE_NUMBERS;
          Property READ_PHONE_STATE : Boolean Read fREAD_PHONE_STATE Write fREAD_PHONE_STATE;
          Property READ_SMS : Boolean Read fREAD_SMS Write fREAD_SMS;
          Property READ_SYNC_SETTINGS : Boolean Read fREAD_SYNC_SETTINGS Write fREAD_SYNC_SETTINGS;
          Property READ_SYNC_STATS : Boolean Read fREAD_SYNC_STATS Write fREAD_SYNC_STATS;
          Property READ_VOICEMAIL : Boolean Read fREAD_VOICEMAIL Write fREAD_VOICEMAIL;
          Property REBOOT : Boolean Read fREBOOT Write fREBOOT;
          Property RECEIVE_BOOT_COMPLETED : Boolean Read fRECEIVE_BOOT_COMPLETED Write fRECEIVE_BOOT_COMPLETED;
          Property RECEIVE_MMS : Boolean Read fRECEIVE_MMS Write fRECEIVE_MMS;
          Property RECEIVE_SMS : Boolean Read fRECEIVE_SMS Write fRECEIVE_SMS;
          Property RECEIVE_WAP_PUSH : Boolean Read fRECEIVE_WAP_PUSH Write fRECEIVE_WAP_PUSH;
          Property RECORD_AUDIO : Boolean Read fRECORD_AUDIO Write fRECORD_AUDIO;
          Property REORDER_TASKS : Boolean Read fREORDER_TASKS Write fREORDER_TASKS;
          Property REQUEST_COMPANION_RUN_IN_BACKGROUND : Boolean Read fREQUEST_COMPANION_RUN_IN_BACKGROUND Write fREQUEST_COMPANION_RUN_IN_BACKGROUND;
          Property REQUEST_COMPANION_USE_DATA_IN_BACKGROUND : Boolean Read fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND Write fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND;
          Property REQUEST_DELETE_PACKAGES : Boolean Read fREQUEST_DELETE_PACKAGES Write fREQUEST_DELETE_PACKAGES;
          Property REQUEST_IGNORE_BATTERY_OPTIMIZATIONS : Boolean Read fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS Write fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS;
          Property REQUEST_INSTALL_PACKAGES : Boolean Read fREQUEST_INSTALL_PACKAGES Write fREQUEST_INSTALL_PACKAGES;
          Property RESTART_PACKAGES : Boolean Read fRESTART_PACKAGES Write fRESTART_PACKAGES;
          Property SEND_RESPOND_VIA_MESSAGE : Boolean Read fSEND_RESPOND_VIA_MESSAGE Write fSEND_RESPOND_VIA_MESSAGE;
          Property SEND_SMS : Boolean Read fSEND_SMS Write fSEND_SMS;
          Property SET_ALARM : Boolean Read fSET_ALARM Write fSET_ALARM;
          Property SET_ALWAYS_FINISH : Boolean Read fSET_ALWAYS_FINISH Write fSET_ALWAYS_FINISH;
          Property SET_ANIMATION_SCALE : Boolean Read fSET_ANIMATION_SCALE Write fSET_ANIMATION_SCALE;
          Property SET_DEBUG_APP : Boolean Read fSET_DEBUG_APP Write fSET_DEBUG_APP;
          Property SET_PREFERRED_APPLICATIONS : Boolean Read fSET_PREFERRED_APPLICATIONS Write fSET_PREFERRED_APPLICATIONS;
          Property SET_PROCESS_LIMIT : Boolean Read fSET_PROCESS_LIMIT Write fSET_PROCESS_LIMIT;
          Property SET_TIME : Boolean Read fSET_TIME Write fSET_TIME;
          Property SET_TIME_ZONE : Boolean Read fSET_TIME_ZONE Write fSET_TIME_ZONE;
          Property SET_WALLPAPER : Boolean Read fSET_WALLPAPER Write fSET_WALLPAPER;
          Property SET_WALLPAPER_HINTS : Boolean Read fSET_WALLPAPER_HINTS Write fSET_WALLPAPER_HINTS;
          Property SIGNAL_PERSISTENT_PROCESSES : Boolean Read fSIGNAL_PERSISTENT_PROCESSES Write fSIGNAL_PERSISTENT_PROCESSES;
          Property STATUS_BAR : Boolean Read fSTATUS_BAR Write fSTATUS_BAR;
          Property SYSTEM_ALERT_WINDOW : Boolean Read fSYSTEM_ALERT_WINDOW Write fSYSTEM_ALERT_WINDOW;
          Property TRANSMIT_IR : Boolean Read fTRANSMIT_IR Write fTRANSMIT_IR;
          Property UNINSTALL_SHORTCUT : Boolean Read fUNINSTALL_SHORTCUT Write fUNINSTALL_SHORTCUT;
          Property UPDATE_DEVICE_STATS : Boolean Read fUPDATE_DEVICE_STATS Write fUPDATE_DEVICE_STATS;
          Property USE_FINGERPRINT : Boolean Read fUSE_FINGERPRINT Write fUSE_FINGERPRINT;
          Property USE_BIOMETRIC : Boolean Read fUSE_BIOMETRIC Write fUSE_BIOMETRIC;
          Property USE_SIP : Boolean Read fUSE_SIP Write fUSE_SIP;
          Property VIBRATE : Boolean Read fVIBRATE Write fVIBRATE;
          Property WAKE_LOCK : Boolean Read fWAKE_LOCK Write fWAKE_LOCK;
          Property WRITE_APN_SETTINGS : Boolean Read fWRITE_APN_SETTINGS Write fWRITE_APN_SETTINGS;
          Property WRITE_CALENDAR : Boolean Read fWRITE_CALENDAR Write fWRITE_CALENDAR;
          Property WRITE_CALL_LOG : Boolean Read fWRITE_CALL_LOG Write fWRITE_CALL_LOG;
          Property WRITE_CONTACTS : Boolean Read fWRITE_CONTACTS Write fWRITE_CONTACTS;
          Property WRITE_EXTERNAL_STORAGE : Boolean Read fWRITE_EXTERNAL_STORAGE Write fWRITE_EXTERNAL_STORAGE;
          Property WRITE_GSERVICES : Boolean Read fWRITE_GSERVICES Write fWRITE_GSERVICES;
          Property WRITE_SECURE_SETTINGS : Boolean Read fWRITE_SECURE_SETTINGS Write fWRITE_SECURE_SETTINGS;
          Property WRITE_SETTINGS : Boolean Read fWRITE_SETTINGS Write fWRITE_SETTINGS;
          Property WRITE_SYNC_SETTINGS : Boolean Read fWRITE_SYNC_SETTINGS Write fWRITE_SYNC_SETTINGS;
          Property WRITE_VOICEMAIL : Boolean Read fWRITE_VOICEMAIL Write fWRITE_VOICEMAIL;
       End;

    TAndroidPermissionsMessages = Class(TPersistent)
       Private
          fSEND_SMS: String;
          fCAPTURE_AUDIO_OUTPUT: String;
          fWRITE_VOICEMAIL: String;
          fWRITE_SECURE_SETTINGS: String;
          fSET_TIME_ZONE: String;
          fREAD_SYNC_SETTINGS: String;
          fMODIFY_AUDIO_SETTINGS: String;
          fKILL_BACKGROUND_PROCESSES: String;
          fGET_TASKS: String;
          fDELETE_CACHE_FILES: String;
          fCAPTURE_VIDEO_OUTPUT: String;
          fBIND_NOTIFICATION_LISTENER_SERVICE: String;
          fUPDATE_DEVICE_STATS: String;
          fREAD_CONTACTS: String;
          fBIND_TELECOM_CONNECTION_SERVICE: String;
          fBIND_PRINT_SERVICE: String;
          fRECORD_AUDIO: String;
          fREAD_FRAME_BUFFER: String;
          fMOUNT_UNMOUNT_FILESYSTEMS: String;
          fPACKAGE_USAGE_STATS: String;
          fGET_PACKAGE_SIZE: String;
          fBROADCAST_STICKY: String;
          fWRITE_SYNC_SETTINGS: String;
          fREAD_SMS: String;
          fREAD_CALENDAR: String;
          fCONTROL_LOCATION_UPDATES: String;
          fBIND_REMOTEVIEWS: String;
          fADD_VOICEMAIL: String;
          fWRITE_CONTACTS: String;
          fREAD_INPUT_STATE: String;
          fCHANGE_NETWORK_STATE: String;
          fCAPTURE_SECURE_VIDEO_OUTPUT: String;
          fCAMERA: String;
          fBIND_NFC_SERVICE: String;
          fWRITE_GSERVICES: String;
          fSET_WALLPAPER: String;
          fREQUEST_DELETE_PACKAGES: String;
          fBIND_VPN_SERVICE: String;
          fBIND_CHOOSER_TARGET_SERVICE: String;
          fINSTALL_PACKAGES: String;
          fCLEAR_APP_CACHE: String;
          fBIND_VR_LISTENER_SERVICE: String;
          fACCESS_NOTIFICATION_POLICY: String;
          fWRITE_CALENDAR: String;
          fSET_TIME: String;
          fDUMP: String;
          fBROADCAST_SMS: String;
          fBIND_TEXT_SERVICE: String;
          fBIND_MIDI_DEVICE_SERVICE: String;
          fBIND_ACCESSIBILITY_SERVICE: String;
          fBATTERY_STATS: String;
          fUSE_SIP: String;
          fUSE_FINGERPRINT: String;
          fUSE_BIOMETRIC : String;
          fTRANSMIT_IR: String;
          fSEND_RESPOND_VIA_MESSAGE: String;
          fREAD_EXTERNAL_STORAGE: String;
          fDIAGNOSTIC: String;
          fBIND_APPWIDGET: String;
          fPERSISTENT_ACTIVITY: String;
          fBIND_CONDITION_PROVIDER_SERVICE: String;
          fSET_ANIMATION_SCALE: String;
          fSET_ALARM: String;
          fREAD_SYNC_STATS: String;
          fCHANGE_WIFI_STATE: String;
          fSTATUS_BAR: String;
          fMOUNT_FORMAT_FILESYSTEMS: String;
          fMANAGE_DOCUMENTS: String;
          fWRITE_EXTERNAL_STORAGE: String;
          fLOCATION_HARDWARE: String;
          fGLOBAL_SEARCH: String;
          fACCESS_NETWORK_STATE: String;
          fVIBRATE: String;
          fRECEIVE_SMS: String;
          fRECEIVE_BOOT_COMPLETED: String;
          fCHANGE_WIFI_MULTICAST_STATE: String;
          fBIND_CARRIER_SERVICES: String;
          fSET_PROCESS_LIMIT: String;
          fREBOOT: String;
          fCHANGE_CONFIGURATION: String;
          fBLUETOOTH_ADMIN: String;
          fBIND_DEVICE_ADMIN: String;
          fBIND_AUTOFILL_SERVICE: String;
          fANSWER_PHONE_CALLS: String;
          fBODY_SENSORS: String;
          fBIND_TV_INPUT: String;
          fBIND_QUICK_SETTINGS_TILE: String;
          fBIND_INCALL_SERVICE: String;
          fSET_DEBUG_APP: String;
          fRESTART_PACKAGES: String;
          fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS: String;
          fBIND_DREAM_SERVICE: String;
          fEXPAND_STATUS_BAR: String;
          fDELETE_PACKAGES: String;
          fACCESS_COARSE_LOCATION: String;
          fSET_ALWAYS_FINISH: String;
          fREAD_CALL_LOG: String;
          fINTERNET: String;
          fINSTANT_APP_FOREGROUND_SERVICE: String;
          fBIND_VISUAL_VOICEMAIL_SERVICE: String;
          fACCESS_WIFI_STATE: String;
          fPROCESS_OUTGOING_CALLS: String;
          fNFC: String;
          fMANAGE_OWN_CALLS: String;
          fINSTALL_SHORTCUT: String;
          fWRITE_APN_SETTINGS: String;
          fUNINSTALL_SHORTCUT: String;
          fSET_WALLPAPER_HINTS: String;
          fMODIFY_PHONE_STATE: String;
          fDISABLE_KEYGUARD: String;
          fBROADCAST_WAP_PUSH: String;
          fBIND_VOICE_INTERACTION: String;
          fBIND_CARRIER_MESSAGING_SERVICE: String;
          fCHANGE_COMPONENT_ENABLED_STATE: String;
          fBLUETOOTH_PRIVILEGED: String;
          fBIND_SCREENING_SERVICE: String;
          fWRITE_CALL_LOG: String;
          fWAKE_LOCK: String;
          fCALL_PRIVILEGED: String;
          fSYSTEM_ALERT_WINDOW: String;
          fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND: String;
          fMASTER_CLEAR: String;
          fINSTALL_LOCATION_PROVIDER: String;
          fSIGNAL_PERSISTENT_PROCESSES: String;
          fMEDIA_CONTENT_CONTROL: String;
          fFACTORY_TEST: String;
          fBLUETOOTH: String;
          fACCESS_CHECKIN_PROPERTIES: String;
          fREQUEST_COMPANION_RUN_IN_BACKGROUND: String;
          fGET_ACCOUNTS_PRIVILEGED: String;
          fBROADCAST_PACKAGE_REMOVED: String;
          fACCESS_LOCATION_EXTRA_COMMANDS: String;
          fWRITE_SETTINGS: String;
          fREQUEST_INSTALL_PACKAGES: String;
          fREORDER_TASKS: String;
          fRECEIVE_WAP_PUSH: String;
          fREAD_PHONE_STATE: String;
          fREAD_LOGS: String;
          fBIND_INPUT_METHOD: String;
          fSET_PREFERRED_APPLICATIONS: String;
          fRECEIVE_MMS: String;
          fREAD_VOICEMAIL: String;
          fREAD_PHONE_NUMBERS: String;
          fBIND_WALLPAPER: String;
          fACCOUNT_MANAGER: String;
          fGET_ACCOUNTS: String;
          fCALL_PHONE: String;
          fACCESS_FINE_LOCATION: String;
       Published
          Property ACCESS_CHECKIN_PROPERTIES : String Read fACCESS_CHECKIN_PROPERTIES Write fACCESS_CHECKIN_PROPERTIES;
          Property ACCESS_COARSE_LOCATION : String Read fACCESS_COARSE_LOCATION Write fACCESS_COARSE_LOCATION;
          Property ACCESS_FINE_LOCATION : String Read fACCESS_FINE_LOCATION Write fACCESS_FINE_LOCATION;
          Property ACCESS_LOCATION_EXTRA_COMMANDS : String Read fACCESS_LOCATION_EXTRA_COMMANDS Write fACCESS_LOCATION_EXTRA_COMMANDS;
          Property ACCESS_NETWORK_STATE : String Read fACCESS_NETWORK_STATE Write fACCESS_NETWORK_STATE;
          Property ACCESS_NOTIFICATION_POLICY : String Read fACCESS_NOTIFICATION_POLICY Write fACCESS_NOTIFICATION_POLICY;
          Property ACCESS_WIFI_STATE : String Read fACCESS_WIFI_STATE Write fACCESS_WIFI_STATE;
          Property ACCOUNT_MANAGER : String Read fACCOUNT_MANAGER Write fACCOUNT_MANAGER;
          Property ADD_VOICEMAIL : String Read fADD_VOICEMAIL Write fADD_VOICEMAIL;
          Property ANSWER_PHONE_CALLS : String Read fANSWER_PHONE_CALLS Write fANSWER_PHONE_CALLS;
          Property BATTERY_STATS : String Read fBATTERY_STATS Write fBATTERY_STATS;
          Property BIND_ACCESSIBILITY_SERVICE : String Read fBIND_ACCESSIBILITY_SERVICE Write fBIND_ACCESSIBILITY_SERVICE;
          Property BIND_APPWIDGET : String Read fBIND_APPWIDGET Write fBIND_APPWIDGET;
          Property BIND_AUTOFILL_SERVICE : String Read fBIND_AUTOFILL_SERVICE Write fBIND_AUTOFILL_SERVICE;
          Property BIND_CARRIER_MESSAGING_SERVICE : String Read fBIND_CARRIER_MESSAGING_SERVICE Write fBIND_CARRIER_MESSAGING_SERVICE;
          Property BIND_CARRIER_SERVICES : String Read fBIND_CARRIER_SERVICES Write fBIND_CARRIER_SERVICES;
          Property BIND_CHOOSER_TARGET_SERVICE : String Read fBIND_CHOOSER_TARGET_SERVICE Write fBIND_CHOOSER_TARGET_SERVICE;
          Property BIND_CONDITION_PROVIDER_SERVICE : String Read fBIND_CONDITION_PROVIDER_SERVICE Write fBIND_CONDITION_PROVIDER_SERVICE;
          Property BIND_DEVICE_ADMIN : String Read fBIND_DEVICE_ADMIN Write fBIND_DEVICE_ADMIN;
          Property BIND_DREAM_SERVICE : String Read fBIND_DREAM_SERVICE Write fBIND_DREAM_SERVICE;
          Property BIND_INCALL_SERVICE : String Read fBIND_INCALL_SERVICE Write fBIND_INCALL_SERVICE;
          Property BIND_INPUT_METHOD : String Read fBIND_INPUT_METHOD Write fBIND_INPUT_METHOD;
          Property BIND_MIDI_DEVICE_SERVICE : String Read fBIND_MIDI_DEVICE_SERVICE Write fBIND_MIDI_DEVICE_SERVICE;
          Property BIND_NFC_SERVICE : String Read fBIND_NFC_SERVICE Write fBIND_NFC_SERVICE;
          Property BIND_NOTIFICATION_LISTENER_SERVICE : String Read fBIND_NOTIFICATION_LISTENER_SERVICE Write fBIND_NOTIFICATION_LISTENER_SERVICE;
          Property BIND_PRINT_SERVICE : String Read fBIND_PRINT_SERVICE Write fBIND_PRINT_SERVICE;
          Property BIND_QUICK_SETTINGS_TILE : String Read fBIND_QUICK_SETTINGS_TILE Write fBIND_QUICK_SETTINGS_TILE;
          Property BIND_REMOTEVIEWS : String Read fBIND_REMOTEVIEWS Write fBIND_REMOTEVIEWS;
          Property BIND_SCREENING_SERVICE : String Read fBIND_SCREENING_SERVICE Write fBIND_SCREENING_SERVICE;
          Property BIND_TELECOM_CONNECTION_SERVICE : String Read fBIND_TELECOM_CONNECTION_SERVICE Write fBIND_TELECOM_CONNECTION_SERVICE;
          Property BIND_TEXT_SERVICE : String Read fBIND_TEXT_SERVICE Write fBIND_TEXT_SERVICE;
          Property BIND_TV_INPUT : String Read fBIND_TV_INPUT Write fBIND_TV_INPUT;
          Property BIND_VISUAL_VOICEMAIL_SERVICE : String Read fBIND_VISUAL_VOICEMAIL_SERVICE Write fBIND_VISUAL_VOICEMAIL_SERVICE;
          Property BIND_VOICE_INTERACTION : String Read fBIND_VOICE_INTERACTION Write fBIND_VOICE_INTERACTION;
          Property BIND_VPN_SERVICE : String Read fBIND_VPN_SERVICE Write fBIND_VPN_SERVICE;
          Property BIND_VR_LISTENER_SERVICE : String Read fBIND_VR_LISTENER_SERVICE Write fBIND_VR_LISTENER_SERVICE;
          Property BIND_WALLPAPER : String Read fBIND_WALLPAPER Write fBIND_WALLPAPER;
          Property BLUETOOTH : String Read fBLUETOOTH Write fBLUETOOTH;
          Property BLUETOOTH_ADMIN : String Read fBLUETOOTH_ADMIN Write fBLUETOOTH_ADMIN;
          Property BLUETOOTH_PRIVILEGED : String Read fBLUETOOTH_PRIVILEGED Write fBLUETOOTH_PRIVILEGED;
          Property BODY_SENSORS : String Read fBODY_SENSORS Write fBODY_SENSORS;
          Property BROADCAST_PACKAGE_REMOVED : String Read fBROADCAST_PACKAGE_REMOVED Write fBROADCAST_PACKAGE_REMOVED;
          Property BROADCAST_SMS : String Read fBROADCAST_SMS Write fBROADCAST_SMS;
          Property BROADCAST_STICKY : String Read fBROADCAST_STICKY Write fBROADCAST_STICKY;
          Property BROADCAST_WAP_PUSH : String Read fBROADCAST_WAP_PUSH Write fBROADCAST_WAP_PUSH;
          Property CALL_PHONE : String Read fCALL_PHONE Write fCALL_PHONE;
          Property CALL_PRIVILEGED : String Read fCALL_PRIVILEGED Write fCALL_PRIVILEGED;
          Property CAMERA : String Read fCAMERA Write fCAMERA;
          Property CAPTURE_AUDIO_OUTPUT : String Read fCAPTURE_AUDIO_OUTPUT Write fCAPTURE_AUDIO_OUTPUT;
          Property CAPTURE_SECURE_VIDEO_OUTPUT : String Read fCAPTURE_SECURE_VIDEO_OUTPUT Write fCAPTURE_SECURE_VIDEO_OUTPUT;
          Property CAPTURE_VIDEO_OUTPUT : String Read fCAPTURE_VIDEO_OUTPUT Write fCAPTURE_VIDEO_OUTPUT;
          Property CHANGE_COMPONENT_ENABLED_STATE : String Read fCHANGE_COMPONENT_ENABLED_STATE Write fCHANGE_COMPONENT_ENABLED_STATE;
          Property CHANGE_CONFIGURATION : String Read fCHANGE_CONFIGURATION Write fCHANGE_CONFIGURATION;
          Property CHANGE_NETWORK_STATE : String Read fCHANGE_NETWORK_STATE Write fCHANGE_NETWORK_STATE;
          Property CHANGE_WIFI_MULTICAST_STATE : String Read fCHANGE_WIFI_MULTICAST_STATE Write fCHANGE_WIFI_MULTICAST_STATE;
          Property CHANGE_WIFI_STATE : String Read fCHANGE_WIFI_STATE Write fCHANGE_WIFI_STATE;
          Property CLEAR_APP_CACHE : String Read fCLEAR_APP_CACHE Write fCLEAR_APP_CACHE;
          Property CONTROL_LOCATION_UPDATES : String Read fCONTROL_LOCATION_UPDATES Write fCONTROL_LOCATION_UPDATES;
          Property DELETE_CACHE_FILES : String Read fDELETE_CACHE_FILES Write fDELETE_CACHE_FILES;
          Property DELETE_PACKAGES : String Read fDELETE_PACKAGES Write fDELETE_PACKAGES;
          Property DIAGNOSTIC : String Read fDIAGNOSTIC Write fDIAGNOSTIC;
          Property DISABLE_KEYGUARD : String Read fDISABLE_KEYGUARD Write fDISABLE_KEYGUARD;
          Property DUMP : String Read fDUMP Write fDUMP;
          Property EXPAND_STATUS_BAR : String Read fEXPAND_STATUS_BAR Write fEXPAND_STATUS_BAR;
          Property FACTORY_TEST : String Read fFACTORY_TEST Write fFACTORY_TEST;
          Property GET_ACCOUNTS : String Read fGET_ACCOUNTS Write fGET_ACCOUNTS;
          Property GET_ACCOUNTS_PRIVILEGED : String Read fGET_ACCOUNTS_PRIVILEGED Write fGET_ACCOUNTS_PRIVILEGED;
          Property GET_PACKAGE_SIZE : String Read fGET_PACKAGE_SIZE Write fGET_PACKAGE_SIZE;
          Property GET_TASKS : String Read fGET_TASKS Write fGET_TASKS;
          Property GLOBAL_SEARCH : String Read fGLOBAL_SEARCH Write fGLOBAL_SEARCH;
          Property INSTALL_LOCATION_PROVIDER : String Read fINSTALL_LOCATION_PROVIDER Write fINSTALL_LOCATION_PROVIDER;
          Property INSTALL_PACKAGES : String Read fINSTALL_PACKAGES Write fINSTALL_PACKAGES;
          Property INSTALL_SHORTCUT : String Read fINSTALL_SHORTCUT Write fINSTALL_SHORTCUT;
          Property INSTANT_APP_FOREGROUND_SERVICE : String Read fINSTANT_APP_FOREGROUND_SERVICE Write fINSTANT_APP_FOREGROUND_SERVICE;
          Property INTERNET : String Read fINTERNET Write fINTERNET;
          Property KILL_BACKGROUND_PROCESSES : String Read fKILL_BACKGROUND_PROCESSES Write fKILL_BACKGROUND_PROCESSES;
          Property LOCATION_HARDWARE : String Read fLOCATION_HARDWARE Write fLOCATION_HARDWARE;
          Property MANAGE_DOCUMENTS : String Read fMANAGE_DOCUMENTS Write fMANAGE_DOCUMENTS;
          Property MANAGE_OWN_CALLS : String Read fMANAGE_OWN_CALLS Write fMANAGE_OWN_CALLS;
          Property MASTER_CLEAR : String Read fMASTER_CLEAR Write fMASTER_CLEAR;
          Property MEDIA_CONTENT_CONTROL : String Read fMEDIA_CONTENT_CONTROL Write fMEDIA_CONTENT_CONTROL;
          Property MODIFY_AUDIO_SETTINGS : String Read fMODIFY_AUDIO_SETTINGS Write fMODIFY_AUDIO_SETTINGS;
          Property MODIFY_PHONE_STATE : String Read fMODIFY_PHONE_STATE Write fMODIFY_PHONE_STATE;
          Property MOUNT_FORMAT_FILESYSTEMS : String Read fMOUNT_FORMAT_FILESYSTEMS Write fMOUNT_FORMAT_FILESYSTEMS;
          Property MOUNT_UNMOUNT_FILESYSTEMS : String Read fMOUNT_UNMOUNT_FILESYSTEMS Write fMOUNT_UNMOUNT_FILESYSTEMS;
          Property NFC : String Read fNFC Write fNFC;
          Property PACKAGE_USAGE_STATS : String Read fPACKAGE_USAGE_STATS Write fPACKAGE_USAGE_STATS;
          Property PERSISTENT_ACTIVITY : String Read fPERSISTENT_ACTIVITY Write fPERSISTENT_ACTIVITY;
          Property PROCESS_OUTGOING_CALLS : String Read fPROCESS_OUTGOING_CALLS Write fPROCESS_OUTGOING_CALLS;
          Property READ_CALENDAR : String Read fREAD_CALENDAR Write fREAD_CALENDAR;
          Property READ_CALL_LOG : String Read fREAD_CALL_LOG Write fREAD_CALL_LOG;
          Property READ_CONTACTS : String Read fREAD_CONTACTS Write fREAD_CONTACTS;
          Property READ_EXTERNAL_STORAGE : String Read fREAD_EXTERNAL_STORAGE Write fREAD_EXTERNAL_STORAGE;
          Property READ_FRAME_BUFFER : String Read fREAD_FRAME_BUFFER Write fREAD_FRAME_BUFFER;
          Property READ_INPUT_STATE : String Read fREAD_INPUT_STATE Write fREAD_INPUT_STATE;
          Property READ_LOGS : String Read fREAD_LOGS Write fREAD_LOGS;
          Property READ_PHONE_NUMBERS : String Read fREAD_PHONE_NUMBERS Write fREAD_PHONE_NUMBERS;
          Property READ_PHONE_STATE : String Read fREAD_PHONE_STATE Write fREAD_PHONE_STATE;
          Property READ_SMS : String Read fREAD_SMS Write fREAD_SMS;
          Property READ_SYNC_SETTINGS : String Read fREAD_SYNC_SETTINGS Write fREAD_SYNC_SETTINGS;
          Property READ_SYNC_STATS : String Read fREAD_SYNC_STATS Write fREAD_SYNC_STATS;
          Property READ_VOICEMAIL : String Read fREAD_VOICEMAIL Write fREAD_VOICEMAIL;
          Property REBOOT : String Read fREBOOT Write fREBOOT;
          Property RECEIVE_BOOT_COMPLETED : String Read fRECEIVE_BOOT_COMPLETED Write fRECEIVE_BOOT_COMPLETED;
          Property RECEIVE_MMS : String Read fRECEIVE_MMS Write fRECEIVE_MMS;
          Property RECEIVE_SMS : String Read fRECEIVE_SMS Write fRECEIVE_SMS;
          Property RECEIVE_WAP_PUSH : String Read fRECEIVE_WAP_PUSH Write fRECEIVE_WAP_PUSH;
          Property RECORD_AUDIO : String Read fRECORD_AUDIO Write fRECORD_AUDIO;
          Property REORDER_TASKS : String Read fREORDER_TASKS Write fREORDER_TASKS;
          Property REQUEST_COMPANION_RUN_IN_BACKGROUND : String Read fREQUEST_COMPANION_RUN_IN_BACKGROUND Write fREQUEST_COMPANION_RUN_IN_BACKGROUND;
          Property REQUEST_COMPANION_USE_DATA_IN_BACKGROUND : String Read fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND Write fREQUEST_COMPANION_USE_DATA_IN_BACKGROUND;
          Property REQUEST_DELETE_PACKAGES : String Read fREQUEST_DELETE_PACKAGES Write fREQUEST_DELETE_PACKAGES;
          Property REQUEST_IGNORE_BATTERY_OPTIMIZATIONS : String Read fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS Write fREQUEST_IGNORE_BATTERY_OPTIMIZATIONS;
          Property REQUEST_INSTALL_PACKAGES : String Read fREQUEST_INSTALL_PACKAGES Write fREQUEST_INSTALL_PACKAGES;
          Property RESTART_PACKAGES : String Read fRESTART_PACKAGES Write fRESTART_PACKAGES;
          Property SEND_RESPOND_VIA_MESSAGE : String Read fSEND_RESPOND_VIA_MESSAGE Write fSEND_RESPOND_VIA_MESSAGE;
          Property SEND_SMS : String Read fSEND_SMS Write fSEND_SMS;
          Property SET_ALARM : String Read fSET_ALARM Write fSET_ALARM;
          Property SET_ALWAYS_FINISH : String Read fSET_ALWAYS_FINISH Write fSET_ALWAYS_FINISH;
          Property SET_ANIMATION_SCALE : String Read fSET_ANIMATION_SCALE Write fSET_ANIMATION_SCALE;
          Property SET_DEBUG_APP : String Read fSET_DEBUG_APP Write fSET_DEBUG_APP;
          Property SET_PREFERRED_APPLICATIONS : String Read fSET_PREFERRED_APPLICATIONS Write fSET_PREFERRED_APPLICATIONS;
          Property SET_PROCESS_LIMIT : String Read fSET_PROCESS_LIMIT Write fSET_PROCESS_LIMIT;
          Property SET_TIME : String Read fSET_TIME Write fSET_TIME;
          Property SET_TIME_ZONE : String Read fSET_TIME_ZONE Write fSET_TIME_ZONE;
          Property SET_WALLPAPER : String Read fSET_WALLPAPER Write fSET_WALLPAPER;
          Property SET_WALLPAPER_HINTS : String Read fSET_WALLPAPER_HINTS Write fSET_WALLPAPER_HINTS;
          Property SIGNAL_PERSISTENT_PROCESSES : String Read fSIGNAL_PERSISTENT_PROCESSES Write fSIGNAL_PERSISTENT_PROCESSES;
          Property STATUS_BAR : String Read fSTATUS_BAR Write fSTATUS_BAR;
          Property SYSTEM_ALERT_WINDOW : String Read fSYSTEM_ALERT_WINDOW Write fSYSTEM_ALERT_WINDOW;
          Property TRANSMIT_IR : String Read fTRANSMIT_IR Write fTRANSMIT_IR;
          Property UNINSTALL_SHORTCUT : String Read fUNINSTALL_SHORTCUT Write fUNINSTALL_SHORTCUT;
          Property UPDATE_DEVICE_STATS : String Read fUPDATE_DEVICE_STATS Write fUPDATE_DEVICE_STATS;
          Property USE_FINGERPRINT : String Read fUSE_FINGERPRINT Write fUSE_FINGERPRINT;
          Property USE_BIOMETRIC : String Read fUSE_BIOMETRIC Write fUSE_BIOMETRIC;
          Property USE_SIP : String Read fUSE_SIP Write fUSE_SIP;
          Property VIBRATE : String Read fVIBRATE Write fVIBRATE;
          Property WAKE_LOCK : String Read fWAKE_LOCK Write fWAKE_LOCK;
          Property WRITE_APN_SETTINGS : String Read fWRITE_APN_SETTINGS Write fWRITE_APN_SETTINGS;
          Property WRITE_CALENDAR : String Read fWRITE_CALENDAR Write fWRITE_CALENDAR;
          Property WRITE_CALL_LOG : String Read fWRITE_CALL_LOG Write fWRITE_CALL_LOG;
          Property WRITE_CONTACTS : String Read fWRITE_CONTACTS Write fWRITE_CONTACTS;
          Property WRITE_EXTERNAL_STORAGE : String Read fWRITE_EXTERNAL_STORAGE Write fWRITE_EXTERNAL_STORAGE;
          Property WRITE_GSERVICES : String Read fWRITE_GSERVICES Write fWRITE_GSERVICES;
          Property WRITE_SECURE_SETTINGS : String Read fWRITE_SECURE_SETTINGS Write fWRITE_SECURE_SETTINGS;
          Property WRITE_SETTINGS : String Read fWRITE_SETTINGS Write fWRITE_SETTINGS;
          Property WRITE_SYNC_SETTINGS : String Read fWRITE_SYNC_SETTINGS Write fWRITE_SYNC_SETTINGS;
          Property WRITE_VOICEMAIL : String Read fWRITE_VOICEMAIL Write fWRITE_VOICEMAIL;
       End;

   {$IFDEF ANDROID}

    JFileProvider = interface;

    JFileProviderClass = interface(JContentProviderClass)
       ['{33A87969-5731-4791-90F6-3AD22F2BB822}']
       {class} function getUriForFile(context: JContext; authority: JString; _file: JFile): Jnet_Uri; cdecl;
       {class} function init: JFileProvider; cdecl;
       end;

    [JavaSignature('android/support/v4/content/FileProvider')]
    JFileProvider = interface(JContentProvider)
       ['{12F5DD38-A3CE-4D2E-9F68-24933C9D221B}']
       procedure attachInfo(context: JContext; info: JProviderInfo); cdecl;
       function delete(uri: Jnet_Uri; selection: JString; selectionArgs: TJavaObjectArray<JString>): Integer; cdecl;
       function getType(uri: Jnet_Uri): JString; cdecl;
       function insert(uri: Jnet_Uri; values: JContentValues): Jnet_Uri; cdecl;
       function onCreate: Boolean; cdecl;
       function openFile(uri: Jnet_Uri; mode: JString): JParcelFileDescriptor; cdecl;
       function query(uri: Jnet_Uri; projection: TJavaObjectArray<JString>; selection: JString; selectionArgs: TJavaObjectArray<JString>; sortOrder: JString): JCursor; cdecl;
       function update(uri: Jnet_Uri; values: JContentValues; selection: JString; selectionArgs: TJavaObjectArray<JString>): Integer; cdecl;
       end;

    TJFileProvider = class(TJavaGenericImport<JFileProviderClass, JFileProvider>) end;
    {$ENDIF}

    {$IF DEFINED(VER330) OR DEFINED(VER340)}
    [ComponentPlatformsAttribute (pidAndroid32Arm Or pidAndroid64Arm)]
    {$ELSE}
    [ComponentPlatformsAttribute (pidAndroid)]
    {$ENDIF}
    TAndroidPermissions = Class(TComponent)
       Private
//        FMSG                   : TISMessageDlg;
          FPropList              : PPropList;
          FPropInfo              : PPropInfo;
          FPropListCount         : Integer;
          FPermissionsList       : TStringList;
          FPermissionsDeniedList : TStringList;
          FAutoRequest           : Boolean;
          FDisplayRationale      : Boolean;
          FDisplayHeader         : String;
          FPermissionsRequest    : TAndroidPermissionsNames;
          FPermissionsGranted    : TAndroidPermissionsNames;
          FPermissionsDenied     : TAndroidPermissionsNames;
          FPermissionsMessages   : TAndroidPermissionsMessages;
          FPermissions           : TArray<String>;
          FRequestResponse       : TNotifyEvent;
          FAllPermissionsGranted : TNotifyEvent;
          FSomePermissionsDenied : TNotifyEvent;
          {$IF DEFINED(VER330) OR DEFINED(VER340)}
          procedure PermissionsResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
          {$ENDIF}
       Protected
          {$IF DEFINED(VER330) OR DEFINED(VER340)}
          Procedure Loaded; Override;
          {$ENDIF}
       Public
          Constructor Create(aOwner : TComponent); Override;
          Destructor Destroy; Override;
          {$IF DEFINED(VER330) OR DEFINED(VER340)}
          {$IFDEF ANDROID}
          Function  GetFileUri(aFile: String): JNet_Uri;
          {$ENDIF}
          Function  AllRequiredGranted : Boolean;
          Function  SomePermissionsDenied : Boolean;
          Function  GetPermissionsDenied : TArray<String>;
          Procedure GetPermissionsStatus;
          Procedure RequestPermissions;
          {$ENDIF}
       Published
          Property AutoRequestPermissions  : Boolean                     Read FAutoRequest           Write FAutoRequest;
//        Property DisplayRationale        : Boolean                     Read FDisplayRationale      Write FDisplayRationale;
          Property DisplayHeader           : String                      Read FDisplayHeader         Write FDisplayHeader;
          Property PermissionsRequired     : TAndroidPermissionsNames    Read FPermissionsRequest    Write FPermissionsRequest;
          Property PermissionsGranted      : TAndroidPermissionsNames    Read FPermissionsGranted;
          Property PermissionsDenied       : TAndroidPermissionsNames    Read FPermissionsDenied;
          Property PermissionsMessages     : TAndroidPermissionsMessages Read FPermissionsMessages   Write FPermissionsMessages;
          Property OnRequestResponse       : TNotifyEvent                Read FRequestResponse       Write FRequestResponse;
          Property OnAllPermissionsGranted : TNotifyEvent                Read FAllPermissionsGranted Write FAllPermissionsGranted;
          Property OnSomePermissionsDenied : TNotifyEvent                Read FSomePermissionsDenied Write FSomePermissionsDenied;
       End;

Implementation

{ TRCPermissions }

constructor TAndroidPermissions.Create(aOwner: TComponent);
var
   I    : Integer;
   Name : String;
begin
inherited;
FAutoRequest           := True;
FDisplayHeader         := 'O aplicativo precisa de permissões para:';
FDisplayRationale      := False;
FPermissionsList       := TStringList.Create;
FPermissionsDeniedList := TStringList.Create;
FPermissionsRequest    := TAndroidPermissionsNames.Create;
FPermissionsGranted    := TAndroidPermissionsNames.Create;
FPermissionsDenied     := TAndroidPermissionsNames.Create;
FPermissionsMessages   := TAndroidPermissionsMessages.Create;
{$IFDEF ANDROID}
FPropListCount         := GetPropList(TypeInfo(TAndroidPermissionsNames), FPropList);
//FMsg                   := TISMessageDlg.Create(Self);
For I := 0 to FPropListCount-1 do
   begin
   FPropInfo := FPropList^[I];
   Name      := FPropInfo^.NameFld.ToString;
   FPermissionsList.Add(Name);
   SetPropValue(FPermissionsMessages, Name, '');
   end;
{$ENDIF}
end;

destructor TAndroidPermissions.Destroy;
begin
FPermissionsList      .DisposeOf;
FPermissionsDeniedList.DisposeOf;
FPermissionsRequest   .DisposeOf;
FPermissionsDenied    .DisposeOf;
FPermissionsGranted   .DisposeOf;
FPermissionsMessages  .DisposeOf;
inherited;
end;

{$IF DEFINED(VER330) OR DEFINED(VER340)}

{$IFDEF ANDROID}
Function TAndroidPermissions.GetFileUri(aFile: String): JNet_Uri;
Var
   FileAtt      : JFile;
   Auth         : JString;
   PackageName  : String;
begin
PackageName := JStringToString(TAndroidHelper.Context.getPackageName);
FileAtt     := TJFile.JavaClass.init(StringToJString(aFile));
Auth        := StringToJString(Packagename+'.fileprovider');
Result      := TJFileProvider.JavaClass.getUriForFile(TAndroidHelper.Context, Auth, FileAtt);
end;
{$ENDIF}

procedure TAndroidPermissions.Loaded;
begin
inherited;
{$IFDEF ANDROID}
if Not (csDesigning in ComponentState) then
   Begin
   TThread.CreateAnonymousThread(
      procedure
      Begin
      Sleep(200);
      TThread.Queue(Nil,
         Procedure
         Begin
         GetPermissionsStatus;
         if FAutoRequest And Not AllRequiredGranted then RequestPermissions;
         End);
      End).Start;
   End;
{$ENDIF}
end;

function TAndroidPermissions.GetPermissionsDenied: TArray<String>;
Var
   I, Q : Integer;
begin
Q := 0;
for I := 0 to FPermissionsList.Count-1 do
   Begin
   If (GetPropValue(FPermissionsRequest, FPermissionsList[I]) = True) And
      (GetPropValue(FPermissionsDenied,  FPermissionsList[I]) = True) Then
      Inc(Q);
   End;
SetLength(Result, Q);
Q := 0;
for I := 0 to FPermissionsList.Count-1 do
   Begin
   If (GetPropValue(FPermissionsRequest, FPermissionsList[I]) = True) And
      (GetPropValue(FPermissionsDenied,  FPermissionsList[I]) = True) Then
      Begin
      Result[Q] := FPermissionsList[I];
      Inc(Q);
      End;
   End;
end;

procedure TAndroidPermissions.GetPermissionsStatus;
Var
   I : Integer;
begin
FPermissionsDeniedList.Clear;
for I := 0 to FPermissionsList.Count-1 do
   Begin
   If PermissionsService.IsPermissionGranted('android.permission.'+FPermissionsList[I]) Then
      Begin
      SetPropValue(FPermissionsGranted, FPermissionsList[I], True);
      SetPropValue(FPermissionsDenied,  FPermissionsList[I], False);
      End
   Else
      Begin
      SetPropValue(FPermissionsGranted, FPermissionsList[I], False);
      SetPropValue(FPermissionsDenied,  FPermissionsList[I], True);
      If GetPropValue(FPermissionsRequest, FPermissionsList[I]) = True Then  //Comparado com true pq retorno é Variant
         Begin
         FPermissionsDeniedList.Add(FPermissionsList[I]);
         End;
      End;
   End;
end;

function TAndroidPermissions.AllRequiredGranted: Boolean;
{$IFDEF ANDROID}
Var
   I : Integer;
{$ENDIF}
begin
Result := True;
{$IFDEF ANDROID}
for I := 0 to FPermissionsList.Count-1 do
   Begin
   If (GetPropValue(FPermissionsRequest, FPermissionsList[I]) = True) And
      (GetPropValue(FPermissionsDenied,  FPermissionsList[I]) = True) Then
      Result := False;
   End;
{$ENDIF}
end;

function TAndroidPermissions.SomePermissionsDenied: Boolean;
begin
Result := Not AllRequiredGranted;
end;

procedure TAndroidPermissions.PermissionsResult(Sender: TObject; const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>);
begin
GetPermissionsStatus;
if Assigned(OnRequestResponse)                                 then OnRequestResponse(Sender);
if Assigned(OnAllPermissionsGranted) And AllRequiredGranted    then OnAllPermissionsGranted(Sender);
if Assigned(OnSomePermissionsDenied) And SomePermissionsDenied then OnSomePermissionsDenied(Sender);
end;

procedure TAndroidPermissions.RequestPermissions;

   Procedure LDisplayMessage;
   Var
      Permission  : String;
      MessageText : String;
      Text        : String;
      I           : Integer;
   Begin
   MessageText := '';
   for I := 0 to FPermissionsDeniedList.Count-1 do
      Begin
      Permission  := FPermissions[i].Remove(0, 19);
      Text        := GetPropValue(FPermissionsMessages, Permission);
      Text        := Text.Trim;
      if Not Text.IsEmpty then MessageText := MessageText+'- '+Text + #13#10;
      End;
   if Not MessageText.IsEmpty then
      Begin
      MessageText := Self.FDisplayHeader+#13#10+#13#10+MessageText;
//      FMsg.MessageOk(MessageText,
//         Procedure
//         Begin
//         PermissionsService.RequestPermissions(FPermissions, PermissionsResult);
//         End);
      End;
   End;

Var
   I : Integer;
begin
SetLength(FPermissions, FPermissionsDeniedList.Count);
for I := 0 to FPermissionsDeniedList.Count-1 do
   Begin
   FPermissions[I] := 'android.permission.'+FPermissionsDeniedList[I];
   End;
if FDisplayRationale then
   LDisplayMessage
Else
   PermissionsService.RequestPermissions(FPermissions, PermissionsResult);
end;

{$ENDIF}

Initialization

RegisterFMXClasses([TAndroidPermissions]);



end.


