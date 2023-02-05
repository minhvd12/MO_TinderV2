import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:it_job_mobile/providers/detail_profile_provider.dart';
import 'package:it_job_mobile/views/liked/liked_job_post_page.dart';
import 'package:it_job_mobile/providers/liked_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_color.dart';
import '../../constants/app_image_path.dart';
import '../../constants/app_text_style.dart';
import '../../models/entity/featured_job_post.dart';
import '../../shared/applicant_preferences.dart';

class LikedPage extends StatefulWidget {
  const LikedPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LikedPage> createState() => _LikedPageState();
}

class _LikedPageState extends State<LikedPage> {
  List<String> categories = ["Lượt thích", "Đã thích", "Đã kết nối"];
  int selectedIndex = 0;
  List<FeaturedJobPost> companiesInformation = [];
  int companiesInformationLength = 0;
  bool view = false;

  @override
  void initState() {
    final provider = Provider.of<LikedProvider>(context, listen: false);
    final detailProfileProvider =
        Provider.of<DetailProfileProvider>(context, listen: false);
    super.initState();
    provider.getJobPostLiked(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
    companiesInformation = provider.companiesInformationJobPostLiked;
    companiesInformationLength =
        provider.companiesInformationLengthJobPostLiked;
    view = false;
    provider.getLiked(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
    provider.getMatching(detailProfileProvider
        .profileApplicants[ApplicantPreferences.getCurrentIndexProfileId(0)]
        .id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LikedProvider>(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              ImagePath.logo,
              fit: BoxFit.fill,
              width: 10.w,
            ),
            SizedBox(
              width: 1.w,
            ),
            Text(
              "Tagent",
              style: AppTextStyles.h2Black,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2.5.h,
          ),
          SizedBox(
            height: 5.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => buildCategory(index),
            ),
          ),
          (provider.isLoadingJobPostLiked &&
                  provider.isLoadingLiked &&
                  provider.isLoadingMatching)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      itemCount: companiesInformationLength,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.04),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Container(
                                    width: 20.w,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.04),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 0.5.h,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.04),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(16)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 30.h,
                      ),
                    ),
                  ),
                )
              : companiesInformation.isNotEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: GridView.builder(
                            itemCount: companiesInformation.length,
                            itemBuilder: (context, index) {
                              return LikedJobPostPage(
                                companyInformation: companiesInformation[index],
                                view: view,
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 30.h,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          SvgPicture.asset(
                            ImagePath.jobPostEmpty,
                            fit: BoxFit.cover,
                            width: 50.w,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            "Không có bài tuyển dụng nào",
                            style: AppTextStyles.h4Black,
                          )
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget buildCategory(int index) {
    final provider = Provider.of<LikedProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          if (index == 0) {
            companiesInformationLength =
                provider.companiesInformationLengthJobPostLiked;
            companiesInformation = provider.companiesInformationJobPostLiked;
            view = false;
          } else if (index == 1) {
            companiesInformationLength =
                provider.companiesInformationLengthLiked;
            companiesInformation = provider.companiesInformationLiked;
            view = true;
          } else if (index == 2) {
            companiesInformationLength =
                provider.companiesInformationLengthMatching;
            companiesInformation = provider.companiesInformationMatching;
            view = true;
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              categories[index],
              style: selectedIndex == index
                  ? AppTextStyles.h3Black
                  : AppTextStyles.h3Grey,
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              height: 2,
              width: 30,
              color:
                  selectedIndex == index ? AppColor.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
