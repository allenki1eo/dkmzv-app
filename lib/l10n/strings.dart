class S {
  S(this.code);
  final String code;
  bool get isSw => code != 'en';

  String get appName => 'DKMZV';
  String get churchShort => isSw ? 'KKKT DKMZV' : 'ELCT DKMZV';
  String get companion => isSw ? 'Mwenza wa muumini' : 'Member companion';

  String get tabHome => isSw ? 'Nyumbani' : 'Home';
  String get tabIbada => 'Ibada';
  String get tabHymns => isSw ? 'Nyimbo' : 'Hymns';
  String get tabEvents => isSw ? 'Matukio' : 'Events';
  String get tabMore => isSw ? 'Zaidi' : 'More';

  String get language => isSw ? 'Lugha' : 'Language';
  String get swahili => 'Kiswahili';
  String get english => 'English';
  String get toggleHint => isSw ? 'SW / EN' : 'SW / EN';

  String get sundayTimes => isSw ? 'Saa za Jumapili' : 'Sunday times';
  String get announcements => isSw ? 'Matangazo' : 'Announcements';
  String get pinned => isSw ? 'Imebandikwa' : 'Pinned';
  String get thisWeek => isSw ? 'Wiki hii' : 'This week';
  String get latestIbada => isSw ? 'Ibada ya wiki hii' : 'This week’s service';
  String get openIbada => isSw ? 'Fungua ibada' : 'Open order of service';
  String get seeAllEvents => isSw ? 'Matukio yote' : 'All events';
  String get seeAll => isSw ? 'Yote' : 'See all';
  String get roleCardLead => isSw
      ? 'Pastor na ofisi tu — si orodha ya waumini.'
      : 'Pastor and office only — not a member directory.';
  String get fcmStub => isSw
      ? 'Arifa za push bado ni muundo (FCM). Funguo zinapowekwa, tangazo litaweza kufika simuni.'
      : 'Push notices are stubbed (FCM). When keys are added, announcements can reach the phone.';
  String get offlineNote => isSw
      ? 'Nyimbo na ibada ya mwisho zinabaki kwenye simu hata data ikikwama.'
      : 'Hymns and the last-opened bulletin stay on this phone when data is slow.';
  String get whatsappComplement => isSw
      ? 'Programu inasaidia WhatsApp — haichukui nafasi yake.'
      : 'This app complements WhatsApp — it does not replace it.';

  String get readings => isSw ? 'Masomo' : 'Readings';
  String get outline => isSw ? 'Mpangilio' : 'Outline';
  String get theme => isSw ? 'Mada' : 'Theme';
  String get preacher => isSw ? 'Mhubiri' : 'Preacher';
  String get bulletin => isSw ? 'Karatasi / kiungo' : 'Bulletin / link';
  String get openLink => isSw ? 'Fungua kiungo' : 'Open link';
  String get hymnsInService =>
      isSw ? 'Nyimbo za ibada' : 'Hymns in this service';
  String get noService =>
      isSw ? 'Hakuna ibada iliyopangwa bado.' : 'No service is scheduled yet.';
  String get liturgicalColor =>
      isSw ? 'Rangi ya liturujia' : 'Liturgical colour';

  String get searchHymns => isSw
      ? 'Tafuta namba, kichwa au mstari…'
      : 'Search number, title or line…';
  String get favorites => isSw ? 'Pendwa' : 'Favorites';
  String get recent => isSw ? 'Hivi karibuni' : 'Recently opened';
  String get allHymns => isSw ? 'Nyimbo zote' : 'All hymns';
  String get noHymns =>
      isSw ? 'Hakuna wimbo unaolingana.' : 'No matching hymn.';
  String get favoriteAdd => isSw ? 'Weka pendwa' : 'Add favorite';
  String get favoriteRemove => isSw ? 'Ondoa pendwa' : 'Remove favorite';
  String get offlineCached => isSw
      ? 'Nakala imewekwa kwenye simu (bila mtandao).'
      : 'Saved on this phone (works offline).';
  String get hymnSource => isSw ? 'Chanzo' : 'Source';

  String get filterAll => isSw ? 'Yote' : 'All';
  String cat(String id) {
    switch (id) {
      case 'worship':
        return isSw ? 'Ibada' : 'Worship';
      case 'choir':
        return isSw ? 'Kwaya' : 'Choir';
      case 'uw':
        return 'UW';
      case 'youth':
        return isSw ? 'Vijana' : 'Youth';
      case 'confirmation':
        return isSw ? 'Kipaimara' : 'Confirmation';
      case 'meeting':
        return isSw ? 'Mikutano' : 'Meetings';
      default:
        return id;
    }
  }

  String get upcoming => isSw ? 'Vinavyokuja' : 'Upcoming';
  String get noEvents =>
      isSw ? 'Hakuna tukio kwenye kichujio hiki.' : 'No events in this filter.';

  String get giving => isSw ? 'Sadaka' : 'Giving';
  String get givingLead => isSw
      ? 'Toa kwa M-Pesa / Lipa na M-Pesa. Programu haihesabu fedha — ni maelekezo tu.'
      : 'Give via M-Pesa / Lipa na M-Pesa. This app is not a finance ledger — instructions only.';
  String get paybill => 'Paybill';
  String get account => isSw ? 'Akaunti / kumbukumbu' : 'Account / reference';
  String get accountName => isSw ? 'Jina la akaunti' : 'Account name';
  String get till => isSw ? 'Till / Lipa' : 'Till / Lipa';
  String get steps => isSw ? 'Hatua' : 'Steps';
  String get amountTips =>
      isSw ? 'Kiasi cha mfano (TZS)' : 'Sample amounts (TZS)';
  String get purpose => isSw ? 'Nia' : 'Purpose';
  String get iGave => isSw ? 'Nimetoa' : 'I have given';
  String get iGaveHint => isSw
      ? 'Kumbukumbu binafsi kwenye simu yako — si risiti rasmi ya ofisi.'
      : 'A private note on your phone — not an official office receipt.';
  String get amount => isSw ? 'Kiasi (TZS)' : 'Amount (TZS)';
  String get note => isSw ? 'Maelezo (si lazima)' : 'Note (optional)';
  String get saveNote => isSw ? 'Hifadhi Nimetoa' : 'Save I-have-given';
  String get myNotes => isSw ? 'Kumbukumbu zangu' : 'My notes';
  String get copy => isSw ? 'Nakili' : 'Copy';
  String get copied => isSw ? 'Imenakiliwa' : 'Copied';

  String get sermons => isSw ? 'Mahubiri' : 'Sermons';
  String get openMedia => isSw ? 'Fungua sauti / video' : 'Open audio / video';
  String get noSermons => isSw ? 'Hakuna mahubiri bado.' : 'No sermons yet.';
  String get watchInApp => isSw ? 'Tazama hapa' : 'Watch here';
  String get watchYoutube => isSw ? 'Fungua YouTube' : 'Open YouTube';
  String get watchOnYoutubeInstead => isSw
      ? 'Video hii haichezi ndani ya programu. Gusa picha au bonyeza Fungua YouTube.'
      : 'This video will not play inside the app. Tap the poster or use Open YouTube.';
  String get shareLink => isSw ? 'Shiriki kiungo' : 'Share link';
  String get liveNow => isSw ? 'MOJA KWA MOJA' : 'LIVE';
  String get liveLead => isSw
      ? 'Mahubiri mengi yanatiririka YouTube kutoka simu. Tazama hapa au shiriki kiungo.'
      : 'Most sermons stream live on YouTube from a phone. Watch here or share the link.';
  String get youtubeNeedUrl => isSw
      ? 'Kiungo hiki si video ya moja kwa moja — fungua YouTube nje, au ofisi ibandike kiungo cha watch / live.'
      : 'This link is not a playable video yet — open YouTube outside, or the office can paste a watch / live URL.';
  String get latestSermon => isSw ? 'Hubiri la mwisho' : 'Latest sermon';
  String get watchLive => isSw ? 'Tazama moja kwa moja' : 'Watch live';
  String get allSermons => isSw ? 'Mahubiri yote' : 'All sermons';
  String get noSermonYet => isSw
      ? 'Ofisi bado haijabandika kiungo cha YouTube.'
      : 'The office has not pasted a YouTube link yet.';

  // Kiungo cha YouTube — office side
  String get youtubeStudio => isSw ? 'YouTube ya usharika' : 'Parish YouTube';
  String get pasteYoutube =>
      isSw ? 'Bandika kiungo cha YouTube' : 'Paste a YouTube link';
  String get pasteYoutubeHint => isSw
      ? 'Nakili kiungo kutoka YouTube (Share) kisha ubandike hapa. Linakubali watch, youtu.be, live na shorts.'
      : 'Copy the link from YouTube (Share) and paste it here. Watch, youtu.be, live and shorts links all work.';
  String get linkLooksGood => isSw ? 'Kiungo ni sahihi' : 'Link looks good';
  String get linkNotYoutube => isSw
      ? 'Hiki si kiungo cha video ya YouTube.'
      : 'That is not a YouTube video link.';
  String get publishAsSermon =>
      isSw ? 'Weka kwenye Mahubiri' : 'Publish to Mahubiri';
  String get startLiveNow => isSw ? 'Anzisha live sasa' : 'Start live now';
  String get channelLabel => isSw ? 'Kituo cha YouTube' : 'YouTube channel';
  String get channelHint => isSw
      ? 'Bandika kiungo cha kituo (youtube.com/@usharika au /channel/UC…). Kikiwa na UC…, live inachezwa ndani ya programu bila kubandika kiungo kila Jumapili.'
      : 'Paste the channel URL (youtube.com/@parish or /channel/UC…). With a UC… id the live stream plays in-app without pasting a link every Sunday.';
  String get channelLiveTitle => isSw ? 'Live ya kituo' : 'Channel live';
  String get channelLiveNote => isSw
      ? 'Inacheza chochote kinachotiririka sasa kwenye kituo cha usharika.'
      : 'Plays whatever the parish channel is streaming right now.';

  String get congregations => isSw ? 'Masharika' : 'Congregations';
  String get congregationsLead => isSw
      ? 'Kanisa kuu ni Ebenezer. Pia: Angaza na Makedonia.'
      : 'The cathedral is Ebenezer. Also: Angaza and Makedonia.';
  String get cathedral => isSw ? 'Kanisa kuu' : 'Cathedral';
  String get sisterChurch => isSw ? 'Usharika mwenza' : 'Sister congregation';
  String get approximatePin => isSw ? 'Pin la makadirio' : 'Approximate pin';
  String get myCongregation => isSw ? 'Usharika wangu' : 'My congregation';
  String get useThisChurch =>
      isSw ? 'Tumia usharika huu' : 'Use this congregation';

  String get jumuiya => 'Jumuiya';
  String get jumuiyaMap => isSw ? 'Ramani ya jumuiya' : 'Jumuiya map';
  String get jumuiyaLead => isSw
      ? 'Ramani ya OpenStreetMap. Gusa kuweka pin la nyumba yako wakati wa jumuiya. Majina ya kaya tu — si namba za simu.'
      : 'OpenStreetMap. Tap to drop your home pin during jumuiya. Household labels only — not phone numbers.';
  String get osmAttribution => '© OpenStreetMap contributors';
  String get dropHomePin => isSw ? 'Weka pin la nyumba' : 'Drop home pin';
  String get pinDropped => isSw
      ? 'Pin la nyumba limewekwa kwenye jumuiya.'
      : 'Home pin saved on this jumuiya map.';
  String get registerToPin => isSw
      ? 'Sajili jina lako kwanza ili kuweka pin la nyumba.'
      : 'Register your name first to drop a home pin.';
  String get homePins => isSw ? 'Nyumba (jumuiya)' : 'Homes (jumuiya)';
  String get churchPin => isSw ? 'Kanisa' : 'Church';
  String get meetingPin => isSw ? 'Mkutano' : 'Meeting';
  String get tapMapHint => isSw
      ? 'Gusa ramani kuweka au kuhamisha pin la nyumba yako.'
      : 'Tap the map to drop or move your home pin.';

  String get register => isSw ? 'Sajili mwanachama' : 'Member registration';
  String get registerLead => isSw
      ? 'Usajili hafifu kwenye simu hii kwa ofisi. Si orodha ya umma ya simu za waumini.'
      : 'A light registration on this phone for the office. Not a public member phone directory.';
  String get fullName => isSw ? 'Jina kamili' : 'Full name';
  String get household => isSw ? 'Kaya / maelezo' : 'Household / note';
  String get shareMyHome => isSw
      ? 'Onyesha nyumba yangu kwenye ramani ya jumuiya (bila namba ya simu)'
      : 'Show my home on the jumuiya map (no phone number)';
  String get registeredOk => isSw
      ? 'Usajili umehifadhiwa kwenye simu hii.'
      : 'Registration is saved on this phone.';
  String get alreadyRegistered =>
      isSw ? 'Umesajiliwa kwenye simu hii' : 'Registered on this phone';
  String get membersAdmin => isSw ? 'Wanaojisajili' : 'Registrations';
  String get noMembers =>
      isSw ? 'Hakuna aliyejisajili bado.' : 'No registrations yet.';
  String get phoneOfficeOnly => isSw
      ? 'Simu (kwa ofisi kwenye simu hii tu)'
      : 'Phone (office, this device only)';

  String get contact => isSw ? 'Wasiliana' : 'Contact';
  String get map => isSw ? 'Ramani — OpenStreetMap' : 'Map — OpenStreetMap';
  String get officeHours => isSw ? 'Saa za ofisi' : 'Office hours';
  String get roleContacts => isSw ? 'Wasiliano vya wadhifa' : 'Role contacts';
  String get notDirectory => isSw
      ? 'Hii si orodha ya simu za waumini. Pastor na ofisi tu.'
      : 'This is not a member phone directory. Pastor and office only.';
  String get call => isSw ? 'Piga' : 'Call';
  String get email => 'Barua pepe / Email';
  String get about => isSw ? 'Kuhusu usharika' : 'About the congregation';

  String get pastoral => isSw ? 'Ombi la kichungaji' : 'Pastoral request';
  String get pastoralLead => isSw
      ? 'Fomu binafsi kwa ofisi (maombi au ziara). Haiendi kwenye ukuta wa umma.'
      : 'A private form for the office (prayer or visit). It is not a public feed.';
  String get yourName => isSw ? 'Jina lako' : 'Your name';
  String get phoneOptional => isSw ? 'Simu (si lazima)' : 'Phone (optional)';
  String get requestType => isSw ? 'Aina ya ombi' : 'Request type';
  String get prayer => isSw ? 'Maombi' : 'Prayer';
  String get visit => isSw ? 'Ziara' : 'Visit';
  String get message => isSw ? 'Ujumbe' : 'Message';
  String get submit => isSw ? 'Tuma kwa ofisi' : 'Send to the office';
  String get submitted => isSw
      ? 'Ombi limehifadhiwa kwenye kikasha cha ofisi kwenye simu hii.'
      : 'The request is saved in the office inbox on this phone.';
  String get required =>
      isSw ? 'Tafadhali jaza sehemu hii.' : 'Please fill this field.';

  String get moreTitle => isSw ? 'Zaidi' : 'More';
  String get admin => isSw ? 'Msimamizi' : 'Admin';
  String get adminLead => isSw
      ? 'CRUD ndogo: tangazo, ibada, matukio, mahubiri, nyimbo, sadaka, kikasha.'
      : 'Minimal CRUD: notices, ibada, events, sermons, hymns, giving, inbox.';
  String get pin => isSw ? 'PIN ya ofisi' : 'Office PIN';
  String get pinHint => isSw
      ? 'Chaguo-msingi la demo: dkmzv  — badilisha baada ya kujaribu.'
      : 'Demo default: dkmzv  — change it after you try the app.';
  String get unlock => isSw ? 'Fungua' : 'Unlock';
  String get wrongPin => isSw ? 'PIN si sahihi.' : 'Incorrect PIN.';
  String get changePin => isSw ? 'Badilisha PIN' : 'Change PIN';
  String get newPin => isSw ? 'PIN mpya' : 'New PIN';
  String get inbox => isSw ? 'Kikasha cha kichungaji' : 'Pastoral inbox';
  String get unread => isSw ? 'Haijasomwa' : 'Unread';
  String get markRead => isSw ? 'Weka kama somo' : 'Mark read';
  String get emptyInbox => isSw ? 'Hakuna ombi.' : 'No requests.';
  String get add => isSw ? 'Ongeza' : 'Add';
  String get edit => isSw ? 'Hariri' : 'Edit';
  String get delete => isSw ? 'Futa' : 'Delete';
  String get save => isSw ? 'Hifadhi' : 'Save';
  String get cancel => isSw ? 'Ghairi' : 'Cancel';
  String get confirmDelete => isSw ? 'Futa kitu hiki?' : 'Delete this item?';
  String get resetSeed => isSw ? 'Rudisha mbegu' : 'Restore seed';
  String get resetSeedConfirm => isSw
      ? 'Hii inafuta mabadiliko ya msimamizi na kurejesha data ya mfano. Pendwa na Nimetoa vinaweza kubaki kwenye simu.'
      : 'This clears admin edits and restores sample data. Favorites and I-have-given notes may remain on the phone.';
  String get givingAdmin => isSw ? 'Maelezo ya M-Pesa' : 'M-Pesa details';
  String get churchAdmin => isSw ? 'Kanisa na ofisi' : 'Church and office';
  String get sundayAdmin => isSw ? 'Saa za Jumapili' : 'Sunday times';
  String get contactsAdmin => isSw ? 'Wasiliano vya wadhifa' : 'Role contacts';
  String get titleSw => isSw ? 'Kichwa (SW)' : 'Title (SW)';
  String get titleEn => isSw ? 'Kichwa (EN)' : 'Title (EN)';
  String get bodySw => isSw ? 'Maandishi (SW)' : 'Body (SW)';
  String get bodyEn => isSw ? 'Maandishi (EN)' : 'Body (EN)';
  String get date => isSw ? 'Tarehe' : 'Date';
  String get time => isSw ? 'Saa' : 'Time';
  String get place => isSw ? 'Mahali' : 'Place';
  String get lyricsSw => isSw ? 'Maneno (SW)' : 'Lyrics (SW)';
  String get lyricsEn => isSw ? 'Maneno (EN)' : 'Lyrics (EN)';
  String get number => isSw ? 'Namba' : 'Number';
  String get mediaUrl => isSw ? 'Kiungo cha media' : 'Media URL';
  String get saved => isSw ? 'Imehifadhiwa' : 'Saved';

  String get colorGreen => isSw ? 'Kijani' : 'Green';
  String get colorPurple => isSw ? 'Zambarau' : 'Purple';
  String get colorGold => isSw ? 'Dhahabu' : 'Gold';
  String get colorWhite => isSw ? 'Nyeupe' : 'White';
  String get colorWhiteGold => isSw ? 'Nyeupe / dhahabu' : 'White / gold';
  String get colorRed => isSw ? 'Nyekundu' : 'Red';

  String get churchYear => isSw ? 'Mwaka wa kanisa' : 'Church year';
  String get todayInYear =>
      isSw ? 'Leo katika mwaka wa kanisa' : 'Today in the church year';
  String get vestmentToday => isSw ? 'Nguo ya leo' : 'Today’s vestment';
  String get followCalendar => isSw ? 'Fuata kalenda' : 'Follow the calendar';
  String get previewCloth =>
      isSw ? 'Ona rangi (si kalenda)' : 'Preview a colour (not the date)';
  String get lockedToSeason => isSw
      ? 'Rangi za DKMZV zimefungwa kwenye msimu wa liturujia.'
      : 'DKMZV colours lock to the liturgical season.';

  String get seasonAdvent => isSw ? 'Majilio' : 'Advent';
  String get seasonChristmas => isSw ? 'Krismasi' : 'Christmas';
  String get seasonEpiphany => isSw ? 'Epifania' : 'Epiphany';
  String get seasonLent => isSw ? 'Kwaresima' : 'Lent';
  String get seasonPalm => isSw ? 'Jumapili ya Matawi' : 'Palm Sunday';
  String get seasonHolyWeek => isSw ? 'Wiki Takatifu' : 'Holy Week';
  String get seasonGoodFriday => isSw ? 'Ijumaa Kuu' : 'Good Friday';
  String get seasonEaster => isSw ? 'Pasaka' : 'Easter';
  String get seasonPentecost => isSw ? 'Pentekoste' : 'Pentecost';
  String get seasonTrinity => isSw ? 'Utatu Mtakatifu' : 'Holy Trinity';
  String get seasonReformation => isSw ? 'Marekebisho' : 'Reformation';
  String get seasonAllSaints => isSw ? 'Watakatifu wote' : 'All Saints';
  String get seasonOrdinary =>
      isSw ? 'Wakati baada ya Pentekoste' : 'Time after Pentecost';

  String get meaningAdvent => isSw
      ? 'Tungojea Nuruyetu. Zambarau: toba, tumaini, na ufalme unaokuja.'
      : 'We wait for the Light. Purple: repentance, hope, and the coming King.';
  String get meaningChristmas => isSw
      ? 'Neno limekuwa mwili. Nyeupe na dhahabu: furaha, usafi, na utukufu.'
      : 'The Word became flesh. White and gold: joy, purity, and glory.';
  String get meaningEpiphany => isSw
      ? 'Kristus afunuliwa kwa mataifa. Kijani: ukuaji katika nuru.'
      : 'Christ is revealed to the nations. Green: growth in the light.';
  String get meaningLent => isSw
      ? 'Siku arobaini za toba kuelekea msalaba. Zambarau: maandalizi.'
      : 'Forty days of repentance toward the cross. Purple: preparation.';
  String get meaningPalm => isSw
      ? 'Mfalme aingia Yerusalemu. Nyekundu: damu na ushindi wa msalaba.'
      : 'The King enters Jerusalem. Red: the blood and victory of the cross.';
  String get meaningHolyWeek => isSw
      ? 'Njia ya mateso. Zambarau hadi Ijumaa Kuu.'
      : 'The way of the Passion. Purple until Good Friday.';
  String get meaningGoodFriday => isSw
      ? 'Msalaba. Nyekundu (au nyeusi): damu ya Mwokozi.'
      : 'The cross. Red (or black): the Saviour’s blood.';
  String get meaningEaster => isSw
      ? 'Kristus amefufuka. Nyeupe na dhahabu kwa siku hamsini.'
      : 'Christ is risen. White and gold for fifty days.';
  String get meaningPentecost => isSw
      ? 'Roho Mtakatifu ashuka. Nyekundu: moto na zawadi za Roho.'
      : 'The Holy Spirit descends. Red: fire and the Spirit’s gifts.';
  String get meaningTrinity => isSw
      ? 'Baba, Mwana na Roho. Nyeupe: sifa ya Mungu mmoja katika Utatu.'
      : 'Father, Son and Spirit. White: praise of the One God in Trinity.';
  String get meaningReformation => isSw
      ? 'Neno pekee, neema pekee. Nyekundu: Roho na ushuhuda.'
      : 'Word alone, grace alone. Red: the Spirit and witness.';
  String get meaningAllSaints => isSw
      ? 'Kanisa shindani na kanisa limelala. Nyeupe: uzima wa milele.'
      : 'The church militant and the church at rest. White: eternal life.';
  String get meaningOrdinary => isSw
      ? 'Ukuaji wa kila siku katika Neno. Kijani: uhai na matumaini.'
      : 'Daily growth in the Word. Green: life and hope.';

  String get whyPurple => isSw
      ? 'Zambarau — Majilio na Kwaresima: toba, maandalizi, ufalme.'
      : 'Purple — Advent and Lent: repentance, preparation, kingship.';
  String get whyGreen => isSw
      ? 'Kijani — wakati wa kawaida baada ya Epifania na Pentekoste: ukuaji.'
      : 'Green — ordinary time after Epiphany and Pentecost: growth.';
  String get whyWhite => isSw
      ? 'Nyeupe / dhahabu — Krismasi, Pasaka, Utatu, watakatifu: furaha na utukufu.'
      : 'White / gold — Christmas, Easter, Trinity, saints: joy and glory.';
  String get whyRed => isSw
      ? 'Nyekundu — Pentekoste, Matawi, Ijumaa Kuu, Marekebisho, kipaimara: Roho na damu.'
      : 'Red — Pentecost, Palm Sunday, Good Friday, Reformation, confirmation: Spirit and blood.';

  // Mwonekano — appearance
  String get appearance => isSw ? 'Mwonekano' : 'Appearance';
  String get appearanceHint => isSw
      ? 'Chagua mwanga au giza, na picha ya nyuma unayoipenda.'
      : 'Pick light or dark, and the background you like.';
  String get themeMode => isSw ? 'Mwanga na giza' : 'Light and dark';
  String get themeSystem => isSw ? 'Ya simu' : 'System';
  String get themeLight => isSw ? 'Mwanga' : 'Light';
  String get themeDark => isSw ? 'Giza' : 'Dark';
  String get darkModeSwitch => isSw ? 'Hali ya giza' : 'Dark mode';
  String get background => isSw ? 'Picha ya nyuma' : 'Background';
  String get backgroundHint => isSw
      ? 'Picha zimewekwa hafifu ili maandishi yaendelee kusomeka.'
      : 'Backgrounds stay faint so the text keeps reading well.';
  String get parishLook => isSw ? 'Rangi ya usharika' : 'Parish colour';
  String get parishLookHint => isSw
      ? 'Kila usharika una rangi yake. Nguo za ibada hubaki za msimu wa kanisa.'
      : 'Each usharika carries its own colour. Vestments stay with the church season.';

  // Sadaka — offerings
  String get givingGroups => isSw ? 'Aina za sadaka' : 'Kinds of offering';
  String get groupBahasha => isSw ? 'Sadaka za bahasha' : 'Envelope offerings';
  String get groupFungu => isSw ? 'Fungu la kumi' : 'Tithe';
  String get groupShukrani => isSw ? 'Shukrani' : 'Thanksgiving';
  String get groupSadaka => isSw ? 'Sadaka za ibada' : 'Service offerings';
  String get exempt => isSw ? 'Exempt' : 'Exempt';
  String get exemptNote => isSw
      ? 'Bahasha (ujenzi, utumishi, imarisha usharika, n.k.) ni exempt — haziunganishwi na fungu la kumi wala shukrani.'
      : 'Envelopes (building, ministry, strengthening, etc.) are exempt — they are not merged with the tithe or thanksgiving.';
  String get separateNote => isSw
      ? 'Fungu la kumi na shukrani huhesabiwa peke yake.'
      : 'The tithe and thanksgiving are counted on their own.';
  String get payByCard => isSw ? 'Lipa kwa kadi' : 'Pay by card';
  String get payByMpesa => isSw ? 'Lipa kwa M-Pesa' : 'Pay with M-Pesa';
  String get cardComingSoon => isSw
      ? 'Kadi (Stripe) itaunganishwa na ofisi.'
      : 'Card (Stripe) will be connected by the office.';
  String get stripeLink => isSw ? 'Kiungo cha Stripe' : 'Stripe link';
  String get chooseAmount => isSw ? 'Chagua kiasi' : 'Choose an amount';
  String get myGiving => isSw ? 'Kumbukumbu zangu' : 'My records';
  String get givingPrivate => isSw
      ? 'Kumbukumbu hizi zinabaki kwenye simu yako pekee.'
      : 'These records stay on your phone only.';

  // Usajili — registration
  String get registerTitle =>
      isSw ? 'Usajili wa waumini' : 'Member registration';
  String get kaya => isSw ? 'Kaya' : 'Household';
  String get kayaHint =>
      isSw ? 'Mfano: Kaya ya Mwanza' : 'For example: the Mwanza household';
  String get gender => isSw ? 'Jinsia' : 'Gender';
  String get male => isSw ? 'Mwanamume' : 'Male';
  String get female => isSw ? 'Mwanamke' : 'Female';
  String get memberStatus => isSw ? 'Hadhi' : 'Standing';
  String get statusMwanachama => isSw ? 'Mwanachama' : 'Member';
  String get statusKijana => isSw ? 'Kijana' : 'Youth';
  String get statusMtoto => isSw ? 'Mtoto' : 'Child';
  String get statusMgeni => isSw ? 'Mgeni' : 'Visitor';
  String get baptized => isSw ? 'Amebatizwa' : 'Baptised';
  String get confirmed => isSw ? 'Amekipaimara' : 'Confirmed';
  String get birthYear => isSw ? 'Mwaka wa kuzaliwa' : 'Year of birth';
  String get optional => isSw ? 'si lazima' : 'optional';
  String get registeredMembers =>
      isSw ? 'Waumini waliojisajili' : 'Registered members';
  String get searchMembers =>
      isSw ? 'Tafuta jina au kaya' : 'Search name or household';
  String get homePinsNote => isSw
      ? 'Ramani inaonyesha jina la kaya pekee — hakuna namba za simu.'
      : 'The map shows the household label only — never a phone number.';
  String get privacyLead => isSw
      ? 'Taarifa hizi zinakaa kwenye simu hii kwa ajili ya ofisi, si orodha ya umma.'
      : 'These details stay on this phone for the office, not as a public directory.';
  String get address => isSw ? 'Anwani' : 'Address';

  // Ramani — map
  String get geofence => isSw ? 'Mpaka wa jumuiya' : 'Jumuiya boundary';
  String get geofenceHint => isSw
      ? 'Duara linaonyesha eneo la jumuiya. Nyumba zilizo ndani zinahesabiwa hapa.'
      : 'The circle shows the jumuiya area. Homes inside are counted here.';
  String get radius => isSw ? 'Upana (mita)' : 'Radius (metres)';
  String get homesInside => isSw ? 'Nyumba ndani' : 'Homes inside';
  String get homesOutside => isSw ? 'Nje ya mpaka' : 'Outside the boundary';
  String get showAllJumuiya => isSw ? 'Jumuiya zote' : 'All jumuiyas';
  String get mapLegend => isSw ? 'Ufafanuzi' : 'Legend';

  // Msimamizi — admin
  String get adminOverview => isSw ? 'Muhtasari' : 'Overview';
  String get adminToday => isSw ? 'Leo' : 'Today';
  String get goLive => isSw ? 'Tuna live sasa' : 'We are live now';
  String get goLiveHint => isSw
      ? 'Washa hii ibada inapoanza YouTube. Waumini wataona kitufe cha kuangalia.'
      : 'Switch this on when the YouTube service starts. Members see a watch button.';
  String get contentSection => isSw ? 'Maudhui' : 'Content';
  String get peopleSection => isSw ? 'Watu na jumuiya' : 'People and jumuiyas';
  String get moneySection =>
      isSw ? 'Sadaka na malipo' : 'Offerings and payments';
  String get settingsSection => isSw ? 'Mipangilio' : 'Settings';

  String get done => isSw ? 'Sawa' : 'OK';
  String get close => isSw ? 'Funga' : 'Close';
  String get details => isSw ? 'Maelezo' : 'Details';
  String get noConnectionHint => isSw
      ? 'Ikiwa kiungo hakifunguki, data inaweza kuwa dhaifu — jaribu tena baadaye.'
      : 'If a link will not open, data may be weak — try again later.';

  // --- Member-facing home and profile ---

  String get goodMorning => isSw ? 'Habari za asubuhi' : 'Good morning';
  String get goodAfternoon => isSw ? 'Habari za mchana' : 'Good afternoon';
  String get goodEvening => isSw ? 'Habari za jioni' : 'Good evening';
  String greetingFor(int hour) {
    if (hour < 12) return goodMorning;
    if (hour < 17) return goodAfternoon;
    return goodEvening;
  }

  String get welcomeLeadA => isSw ? 'Karibu' : 'Welcome to';
  String get welcomeLeadB => isSw ? 'nyumbani' : 'your church';

  String get myBahasha => isSw ? 'Bahasha yangu' : 'My envelope';
  String get bahashaNumber => isSw ? 'Namba ya bahasha' : 'Envelope number';
  String get bahashaNotSet => isSw
      ? 'Ofisi bado haijakupa namba ya bahasha.'
      : 'The office has not issued your envelope number yet.';
  String get bahashaHint => isSw
      ? 'Tumia namba hii unapotoa sadaka yako.'
      : 'Use this number when you give your offering.';
  String get givenThisYear => isSw ? 'Nimetoa mwaka huu' : 'Given this year';
  String get givingTimes => isSw ? 'Mara' : 'Times';
  String get lastGift => isSw ? 'Mara ya mwisho' : 'Last gift';
  String get giveNow => isSw ? 'Toa sadaka' : 'Give now';
  String get noGiftsYet =>
      isSw ? 'Bado hujaandika sadaka yoyote.' : 'No offerings recorded yet.';

  String get myProfile => isSw ? 'Wasifu wangu' : 'My profile';
  String get notRegistered => isSw ? 'Hujajisajili bado' : 'Not registered yet';
  String get registerForBahasha => isSw
      ? 'Jisajili ili uone bahasha yako na jumuiya yako.'
      : 'Register to see your envelope number and your jumuiya.';
  String get myJumuiya => isSw ? 'Jumuiya yangu' : 'My jumuiya';
  String get noJumuiya => isSw ? 'Haijachaguliwa' : 'Not chosen';
  String get memberSince => isSw ? 'Mwanachama tangu' : 'Member since';
  String get pastoralRowHint =>
      isSw ? 'Faragha — inabaki simuni' : 'Private — stays on this phone';
  String get myChurchFollowUp =>
      isSw ? 'Fuatilia usharika wako' : 'Follow your church';
  String get todaySchedule => isSw ? 'Ratiba ya leo' : "Today's schedule";
  String get weekAhead => isSw ? 'Wiki inayokuja' : 'The week ahead';
  String get nothingToday =>
      isSw ? 'Hakuna tukio leo.' : 'Nothing scheduled today.';
  String get seeSchedule => isSw ? 'Ona ratiba' : 'See schedule';
  String get quickActions => isSw ? 'Njia za haraka' : 'Quick actions';
}
