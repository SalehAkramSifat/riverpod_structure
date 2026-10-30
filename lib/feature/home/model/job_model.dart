class JobModel {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String salary;
  final String jobType;
  final String category;
  final String logoUrl;
  final String postedTime;
  final bool isBookmarked;

  const JobModel({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.category,
    required this.logoUrl,
    required this.postedTime,
    this.isBookmarked = false,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    companyName: json["companyName"] ?? "",
    location: json["location"] ?? "",
    salary: json["salary"] ?? "",
    jobType: json["jobType"] ?? "",
    category: json["category"] ?? "",
    logoUrl: json["logoUrl"] ?? "",
    postedTime: json["postedTime"] ?? "",
    isBookmarked: json["isBookmarked"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "companyName": companyName,
    "location": location,
    "salary": salary,
    "jobType": jobType,
    "category": category,
    "logoUrl": logoUrl,
    "postedTime": postedTime,
    "isBookmarked": isBookmarked,
  };

  JobModel copyWith({
    String? id,
    String? title,
    String? companyName,
    String? location,
    String? salary,
    String? jobType,
    String? category,
    String? logoUrl,
    String? postedTime,
    bool? isBookmarked,
  }) => JobModel(
    id: id ?? this.id,
    title: title ?? this.title,
    companyName: companyName ?? this.companyName,
    location: location ?? this.location,
    salary: salary ?? this.salary,
    jobType: jobType ?? this.jobType,
    category: category ?? this.category,
    logoUrl: logoUrl ?? this.logoUrl,
    postedTime: postedTime ?? this.postedTime,
    isBookmarked: isBookmarked ?? this.isBookmarked,
  );
}

// 📦 Dummy JSON Dataset (API এর বিকল্প হিসেবে ডামি ডেটা)
final List<Map<String, dynamic>> dummyJobsJson = [
  {
    "id": "1",
    "title": "Senior Flutter Developer",
    "companyName": "TechCorp Global",
    "location": "Dhaka, BD (Remote)",
    "salary": "\$1,200 - \$1,800/mo",
    "jobType": "Remote",
    "category": "Technology",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/5968/5968350.png",
    "postedTime": "2 hours ago",
    "isBookmarked": true,
  },
  {
    "id": "2",
    "title": "UI/UX Product Designer",
    "companyName": "Creative Studio",
    "location": "Banani, Dhaka",
    "salary": "\$800 - \$1,200/mo",
    "jobType": "Full-time",
    "category": "Design",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/5968/5968705.png",
    "postedTime": "5 hours ago",
    "isBookmarked": false,
  },
  {
    "id": "3",
    "title": "Backend Engineer (Node/Python)",
    "companyName": "Fintech Solutions",
    "location": "Gulshan, Dhaka",
    "salary": "\$1,000 - \$1,500/mo",
    "jobType": "Full-time",
    "category": "Technology",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/919/919825.png",
    "postedTime": "1 day ago",
    "isBookmarked": false,
  },
  {
    "id": "4",
    "title": "Digital Marketing Specialist",
    "companyName": "Growth Wave",
    "location": "Remote",
    "salary": "\$600 - \$900/mo",
    "jobType": "Part-time",
    "category": "Marketing",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/1006/1006771.png",
    "postedTime": "2 days ago",
    "isBookmarked": true,
  },
  {
    "id": "5",
    "title": "Junior Mobile App Developer",
    "companyName": "DevNest Ltd.",
    "location": "Uttara, Dhaka",
    "salary": "\$400 - \$600/mo",
    "jobType": "Full-time",
    "category": "Technology",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/5968/5968350.png",
    "postedTime": "3 days ago",
    "isBookmarked": false,
  },
  {
    "id": "6",
    "title": "Motion Graphics Animator",
    "companyName": "Pixel Studios",
    "location": "Remote",
    "salary": "\$700 - \$1,100/mo",
    "jobType": "Contract",
    "category": "Design",
    "logoUrl": "https://cdn-icons-png.flaticon.com/512/5968/5968705.png",
    "postedTime": "4 days ago",
    "isBookmarked": false,
  },
];
