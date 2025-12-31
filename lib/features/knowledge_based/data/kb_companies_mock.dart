import '../models/kb_company.dart';

/// لیست کامل استان‌های ایران (برای صفحه انتخاب استان)
const List<String> iranProvinces = [
  'آذربایجان شرقی',
  'آذربایجان غربی',
  'اردبیل',
  'اصفهان',
  'البرز',
  'ایلام',
  'بوشهر',
  'تهران',
  'چهارمحال و بختیاری',
  'خراسان جنوبی',
  'خراسان رضوی',
  'خراسان شمالی',
  'خوزستان',
  'زنجان',
  'سمنان',
  'سیستان و بلوچستان',
  'فارس',
  'قزوین',
  'قم',
  'کردستان',
  'کرمان',
  'کرمانشاه',
  'کهگیلویه و بویراحمد',
  'گلستان',
  'گیلان',
  'لرستان',
  'مازندران',
  'مرکزی',
  'هرمزگان',
  'همدان',
  'یزد',
];

/// دیتای ماک شرکت‌های دانش‌بنیان
const List<KbCompany> kbCompaniesMock = [
  KbCompany(
    id: 'kb1',
    name: 'تحلیل‌گران هوشمند فردا',
    province: 'تهران',
    city: 'تهران',
    domains: ['هوش مصنوعی', 'داده'],
    shortDescription:
        'پلتفرم تحلیل رفتار مشتری و سیستم‌های توصیه‌گر برای فروشگاه‌های آنلاین.',
    description:
        'تحلیل‌گران هوشمند فردا روی توسعه سیستم‌های توصیه‌گر و موتورهای شخصی‌سازی محتوا کار می‌کند. '
        'محصول اصلی ما یک پلتفرم SaaS است که به فروشگاه‌های آنلاین کمک می‌کند رفتار مشتری را تحلیل کرده و '
        'پیشنهادهای هوشمند نمایش دهند.\n\n'
        'در حال حاضر با چند استارتاپ فروشگاهی همکاری داریم و روی مقیاس‌پذیری سیستم و ماژول‌های جدید شخصی‌سازی کار می‌کنیم.',
    isHiring: true,
    openRoles: [
      'مهندس داده (Python)',
      'Back-end Developer (Node.js / Python)',
    ],
    isRemoteFriendly: true,
    website: 'https://future-analytics.example',
    email: 'jobs@future-analytics.ir',
    tags: ['AI', 'Data', 'SaaS'],
  ),
  KbCompany(
    id: 'kb2',
    name: 'راهکارهای ابری نوا',
    province: 'تهران',
    city: 'تهران',
    domains: ['کلاد', 'DevOps'],
    shortDescription:
        'زیرساخت ابری برای استارتاپ‌ها و تیم‌های کوچک، با تمرکز روی استقرار سریع.',
    description:
        'نوا، سرویس زیرساخت ابری مدیریت‌شده برای استارتاپ‌هاست. ما به تیم‌های کوچک کمک می‌کنیم بدون درگیر شدن '
        'با جزییات سرور و کانفیگ، سرویس‌هایشان را روی کلاد مستقر و پایدار نگه دارند.\n\n'
        'محصول ما شامل داشبورد مانیتورینگ، دیپلوی خودکار و بکاپ‌گیری منظم است.',
    isHiring: false,
    openRoles: [],
    isRemoteFriendly: false,
    website: 'https://nova-cloud.example',
    email: 'info@nova-cloud.ir',
    tags: ['Cloud', 'DevOps'],
  ),
  KbCompany(
    id: 'kb3',
    name: 'سلامت دیجیتال آوا',
    province: 'فارس',
    city: 'شیراز',
    domains: ['سلامت دیجیتال', 'موبایل'],
    shortDescription:
        'اپلیکیشن پیگیری دارو و نوبت‌دهی هوشمند برای بیماران مزمن.',
    description:
        'آوا یک استارتاپ سلامت دیجیتال است که روی پایبندی به درمان (Medication Adherence) تمرکز دارد. '
        'اپ ما به بیماران کمک می‌کند داروهای خود را در زمان مناسب مصرف کرده و با پزشک خود در ارتباط باشند.\n\n'
        'همچنین ماژول نوبت‌دهی و پرونده سلامت مختصر هم در حال توسعه است.',
    isHiring: true,
    openRoles: [
      'Flutter Developer',
    ],
    isRemoteFriendly: true,
    website: 'https://ava-health.example',
    email: 'team@ava-health.ir',
    tags: ['HealthTech', 'Flutter'],
  ),
  KbCompany(
    id: 'kb4',
    name: 'دیدبان انرژی هوشمند',
    province: 'اصفهان',
    city: 'اصفهان',
    domains: ['IoT', 'انرژی'],
    shortDescription:
        'سیستم پایش مصرف انرژی در ساختمان‌ها با استفاده از حسگرهای IoT.',
    description:
        'دیدبان انرژی هوشمند روی کاهش مصرف انرژی ساختمان‌های اداری و مسکونی کار می‌کند. '
        'با استفاده از حسگرهای IoT و الگوریتم‌های تحلیل داده، الگوی مصرف را پایش و بهینه‌سازی پیشنهاد می‌دهیم.',
    isHiring: true,
    openRoles: [
      'Embedded Developer',
      'Back-end .NET',
    ],
    isRemoteFriendly: false,
    website: 'https://smart-energy.example',
    email: 'career@smart-energy.ir',
    tags: ['IoT', 'Energy'],
  ),
  KbCompany(
    id: 'kb5',
    name: 'فین‌تک پرداخت‌یاران',
    province: 'خراسان رضوی',
    city: 'مشهد',
    domains: ['فین‌تک', 'وب'],
    shortDescription: 'پلتفرم تسهیم‌پرداخت و کیف پول برای کسب‌وکارهای آنلاین.',
    description:
        'پرداخت‌یاران روی ساخت سرویس‌های فین‌تک برای کسب‌وکارهای آنلاین و مارکت‌پلیس‌ها کار می‌کند. '
        'سرویس تسهیم‌پرداخت و کیف پول داخلی، دو محصول فعلی ما هستند.',
    isHiring: false,
    openRoles: [],
    isRemoteFriendly: true,
    website: 'https://pay-yaran.example',
    email: 'contact@pay-yaran.ir',
    tags: ['Fintech'],
  ),
  KbCompany(
    id: 'kb6',
    name: 'آزمایشگاه رباتیک هوشمند',
    province: 'تهران',
    city: 'تهران',
    domains: ['رباتیک', 'هوش مصنوعی'],
    shortDescription:
        'توسعه ربات‌های سرویس‌محور برای محیط‌های آموزشی و نمایشگاهی.',
    description:
        'آزمایشگاه رباتیک هوشمند چند سالی است روی ربات‌های سرویس‌محور (Service Robots) برای محیط‌های آموزشی، '
        'نمایشگاهی و فروشگاهی کار می‌کند. ترکیبی از بینایی ماشین، مسیریابی و تعامل صوتی در محصولات ما استفاده می‌شود.',
    isHiring: true,
    openRoles: [
      'Computer Vision Engineer',
      'ROS Developer',
    ],
    isRemoteFriendly: false,
    website: 'https://smart-robotics.example',
    email: 'join@smart-robotics.ir',
    tags: ['Robotics', 'AI'],
  ),
];
