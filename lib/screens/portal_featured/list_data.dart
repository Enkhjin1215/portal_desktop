import 'dart:convert';

class Event {
  final String name;
  final String description;
  final String coverImage;
  final String coverImage2;
  final String slug;
  final bool cover;
  final DateTime date;
  final List<String> gallery;

  Event({
    required this.name,
    required this.description,
    required this.coverImage,
    required this.coverImage2,
    required this.slug,
    required this.cover,
    required this.date,
    required this.gallery,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      description: json['description'],
      coverImage: json['coverImage'],
      coverImage2: json['coverImage2'],
      slug: json['slug'],
      cover: json['cover'],
      date: DateTime.parse(json['date']),
      gallery: List<String>.from(json['gallery']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'coverImage2': coverImage2,
      'slug': slug,
      'cover': cover,
      'date': date.toIso8601String(),
      'gallery': gallery,
    };
  }
}

class EventList {
  List<Event> getList() => raw.map((map) => Event.fromJson(map)).map((item) => item).toList();

  final List<Map<String, dynamic>> raw = [
    {
      'name': 'Night Train хамтлагийн "Цэнхэр шувуу" цомгийн 20 жилийн ойн Tribute тоглолт',
      'description':
          'Шөнийн галт тэрэг хамтлагийн "Цэнхэр шувуу" цомгийн 20 жилийн ойн Tribute тоглолт нь 2024 оны 02 сарын 03-ны өдөр болсон бөгөөд энэ нь "Portal.mn"-ийн зохион байгуулсан анхны тоглолт гэдгээрээ онцлог юм. \n' +
              '\n' +
              'Хүндэтгэлийн тоглолтод уригдан ирсэн Nisvanis, The Royal Heartaches, The Colors, Choijoo зэрэг зочин хамтлаг, дуучид "Шөнийн галт тэрэг" хамтлагийн сонгогдсон дуунуудыг өөрсдийн стилиэр амилуулан анх удаа тоглож, үзэгч фенүүддээ мартагдашгүй нэгэн дурамжтай үдшийг бэлэг болгон барьсан юм. ',
      'coverImage': 'https://cdn.portal.mn/uploads/nt-cover.png',
      'coverImage2': 'https://cdn.portal.mn/uploads/nt-cover-v.png',
      'className': 'hideDesktop',
      'slug': 'night-train-tribute-20-years',
      'cover': true,
      'date': '2023-01-12T07:00:00.000Z',
      'gallery': [
        'https://cdn.portal.mn/special/Night%20train/473645736_122208151436129790_2224227345708675527_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474045936_122208153188129790_2964610498060644835_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474046830_122208153092129790_3599358830439709875_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474059076_122208420836129790_8043029196203276909_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474059716_122208422588129790_4074924154985118505_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474163734_122208421058129790_2491839247233862680_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474214038_122208420764129790_9073587324622276870_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474220353_122208421226129790_4200536082538036565_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474464954_122208420998129790_2629035723728825581_n.jpg',
        'https://cdn.portal.mn/special/Night%20train/474497594_122208422702129790_6377998089584242252_n.jpg',
      ],
    },
    {
      'name': 'The Mongol Khan at Sands Theatre in Singapore',
      'description':
          'Дэлхийн театрын ертөнцөд Монгол Тамгалал болж буй "Тамгагүй Төр" жүжгийн олон улсын West End хувилбар болох "Монгол Хаан" жүжгийг Сингапурын алдарт Marina Bay Sands-н Sands театрт толилуулсан билээ. \n' +
              'Шекспирийн өлгий нутагт 100 Монголчууд, Монгол хувцас, Монгол гутлаа өмсөөд, дэлхийн театрын шилдгүүдтэй мөр зэрэгцэн түүхэндээ анх удаа 40000 үзэгчдэд тоглосон. Дэлхийн тэргүүлэгч хэвлэлүүд болох Times, Guardian, Financial Times, Telegraph-c өндөр үнэлгээ авч, 50 гаруй шүүмжлэгчдээс 4 од үнэлгээ авсан энэхүү West End-н Монгол бүтээл - Азийн бар Сингапур улсад 2024 оны 10 сард Азийн нээлтээ хийсэн юм. ',
      'coverImage': 'https://cdn.portal.mn/uploads/6e8bfae7-dca4-40a9-82b2-d99278d1efce.jpeg',
      'coverImage2': 'https://cdn.portal.mn/uploads/602945f0-e44c-49d1-a8f1-e6aab4a626a4.jpeg',
      'slug': 'the-mongol-khan-theatre',
      'cover': true,
      'date': '2024-07-20T07:00:00.000Z',
      'gallery': [
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.05.224.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.11.716.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.23.252.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.27.596.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.32.034.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.33.622.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.36.250.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.40.819.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.41.903.jpg',
        'https://cdn.portal.mn/special/Mongol%20Khan/videoplayback%20(2).mp4_snapshot_00.47.367.jpg',
      ],
    },
    {
      'name': 'ПУУЖИН БАЯРАА тоглолт',
      'description': 'Реппер Rokitbay-ийн бие даасан ПУУЖИН БАЯРАА тоглолт нь 2024 оны намрын Highlight тоглолт гэж гарчиглах нь буруудахгүй болов уу. Цэнгэлдэх хүрээлэнг дүүргэж, өөрийн хит дуунуудаараа ирсэн бүгдийг бүхэлд нь нэгэн зэрэг доргиож чадсан билээ. \n' +
          'Rokitbay өөрийн дөрөв дэх цомог буюу "Odyssey" цомгийн бүх дуу болох нийт есөн дууг клиптэй болгох ажлыг хийсэн ба тоглолт дээрээ фенүүддээ шинэ дуунуудаараа бэлэг барьсан юм.\n' +
          '\n' +
          'ПУУЖИН БАЯРАА тоглолтын тасалбарыг Portal.mn бүрэн хариуцаж ажилласан бөгөөд амжилттай 25,000+ тасалбар борлуулан "Sold out" болсон. \n' +
          '\n' +
          'Portal.mn  дээр хэрэглэгчид өөр хоорондоо "Хоёрдогч зах зээл"-ээр дамжуулан албан ёсны, баталгаатай тасалбараа зарах болон авах боломжийн бүрдүүлсэн билээ. \n' +
          'Түүнчлэн Portal.mn -ийн Bar хэсгээс уух зүйлсээ урьдчилан захиалах боломжтой болсноор үзэгчид тоглолтын дундуур урт дараалал үүсгэн оочирлож, цаг алдах асуудлыг шийдэж чадсан байдаг. ',
      'coverImage': 'https://cdn.portal.mn/uploads/05ee311b-f828-4807-acb5-0b9b14f3ff75.jpeg',
      'coverImage2': 'https://cdn.portal.mn/uploads/0aab5600-00f3-44d0-b1fa-93ddcb115155.webp',
      'slug': 'puujin-bayraa-2024',
      'cover': false,
      'date': '2024-09-14T07:00:00.000Z',
      'gallery': [
        'https://cdn.portal.mn/special/Rokitbay/rokitbay%20after%203.mp4_snapshot_00.01.501.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_00.15.515.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_00.30.530.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_00.57.368.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.11.839.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.18.078.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.26.586.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.32.092.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.40.282.jpg',
        'https://cdn.portal.mn/special/Rokitbay/rokitbay after 3.mp4_snapshot_01.41.503.jpg',
      ],
    },
    {
      'name': 'ARA FEST 2024',
      'description':
          'Монголын нүүдлийн өв соёлыг таниулан сурталчлах, давтагдашгүй үнэт өв, урлагийн бүтээлийг толилуулах, уламжлалаа хайрлан хүндэтгэх сэдлийг төрүүлэх, дэлгэрүүлэх, мөн олон улсын жуулчдад жил бүр үзүүлэх аялал жуулчлалын Хангайн бүсийн бүтээгдэхүүнийг бий болгохоор АРА Фест 2024 өв соёлын хөтөлбөр, арга хэмжээнүүдийг зохион байгуулагдсан ба Portal.mn тасалбар борлуулалт дээр хамтран ажилласан билээ.\n' +
              '\n' +
              'Монголын хөгжмийн ертөнцийн онцлог болсон этник хэв маяг, ардын өв соёл, хувцас өмсгөлийн уламжлалыг шингээсэн МОНГОЛ ПОП урсгалыг дэлхий дахинд сурталчлан таниулах "МОНГОЛ ПОП" хөгжмийн их наадам АРА ФЕСТ 2024 - Хангайн бүсийн өв соёлын сарын чухал арга хэмжээ 2024 оны 7-р сарын 13-14-ний өдрүүдэд болсон билээ.',
      'coverImage': 'https://cdn.portal.mn/uploads/6aeac507-92d0-4267-9e9e-ce47837eb87b.jpeg',
      'coverImage2': 'https://cdn.portal.mn/uploads/e792a05a-aeb2-4285-b13d-1b5b92a5371e.jpeg',
      'slug': 'ara-fest-2024',
      'cover': true,
      'date': '2024-08-23T07:00:00.000Z',
      'gallery': [
        'https://cdn.portal.mn/special/ARA/ARA%20Fest%202024%20Aftermovie%20-%20ARA%20Complex.mp4_snapshot_00.19.743.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.24.415.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.29.787.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.36.248.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.41.666.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.44.330.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_00.50.311.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_04.17.704.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_04.57.635.jpg',
        'https://cdn.portal.mn/special/ARA/ARA Fest 2024 Aftermovie - ARA Complex.mp4_snapshot_05.02.173.jpg',
      ],
    },
  ];
}
