class S {
  S(this.code);
  final String code;
  bool get isSw => code != 'en';

  String get appName => 'DKMZV';
  String get churchShort =>
      isSw ? 'KKKT DKMZV — Angaza' : 'ELCT DKMZV — Angaza';
  String get companion =>
      isSw ? 'Mwenza wa muumini' : 'Member companion';

  String get tabHome => isSw ? 'Tangazo' : 'Home';
  String get tabIbada => 'Ibada';
  String get tabHymns => isSw ? 'Nyimbo' : 'Hymns';
  String get tabEvents => isSw ? 'Matukio' : 'Events';
  String get tabMore => isSw ? 'Zaidi' : 'More';

  String get language => isSw ? 'Lugha' : 'Language';
  String get swahili => 'Kiswahili';
  String get english => 'English';
  String get toggleHint => isSw ? 'SW / EN' : 'SW / EN';

  String get sundayTimes =>
      isSw ? 'Saa za Jumapili' : 'Sunday times';
  String get announcements =>
      isSw ? 'Matangazo' : 'Announcements';
  String get pinned => isSw ? 'Imebandikwa' : 'Pinned';
  String get thisWeek => isSw ? 'Wiki hii' : 'This week';
  String get latestIbada =>
      isSw ? 'Ibada ya wiki hii' : 'This week’s service';
  String get openIbada => isSw ? 'Fungua ibada' : 'Open order of service';
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
  String get hymnsInService => isSw ? 'Nyimbo za ibada' : 'Hymns in this service';
  String get noService =>
      isSw ? 'Hakuna ibada iliyopangwa bado.' : 'No service is scheduled yet.';
  String get liturgicalColor => isSw ? 'Rangi ya liturujia' : 'Liturgical colour';

  String get searchHymns =>
      isSw ? 'Tafuta namba, kichwa au mstari…' : 'Search number, title or line…';
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
  String get amountTips => isSw ? 'Kiasi cha mfano (TZS)' : 'Sample amounts (TZS)';
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

  String get contact => isSw ? 'Wasiliana' : 'Contact';
  String get map => isSw ? 'Ramani — Shinyanga' : 'Map — Shinyanga';
  String get officeHours => isSw ? 'Saa za ofisi' : 'Office hours';
  String get roleContacts =>
      isSw ? 'Wasiliano vya wadhifa' : 'Role contacts';
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
  String get required => isSw ? 'Tafadhali jaza sehemu hii.' : 'Please fill this field.';

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
  String get emptyInbox =>
      isSw ? 'Hakuna ombi.' : 'No requests.';
  String get add => isSw ? 'Ongeza' : 'Add';
  String get edit => isSw ? 'Hariri' : 'Edit';
  String get delete => isSw ? 'Futa' : 'Delete';
  String get save => isSw ? 'Hifadhi' : 'Save';
  String get cancel => isSw ? 'Ghairi' : 'Cancel';
  String get confirmDelete =>
      isSw ? 'Futa kitu hiki?' : 'Delete this item?';
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
  String get followCalendar =>
      isSw ? 'Fuata kalenda' : 'Follow the calendar';
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

  String get done => isSw ? 'Sawa' : 'OK';
  String get close => isSw ? 'Funga' : 'Close';
  String get details => isSw ? 'Maelezo' : 'Details';
  String get noConnectionHint => isSw
      ? 'Ikiwa kiungo hakifunguki, data inaweza kuwa dhaifu — jaribu tena baadaye.'
      : 'If a link will not open, data may be weak — try again later.';
}
