import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/job_position.dart';
import 'package:it_job_mobile/models/entity/job_post_skill.dart';
import 'package:it_job_mobile/models/entity/working_style.dart';
import 'package:it_job_mobile/repositories/implement/likes_implement.dart';

import '../../models/entity/store_image.dart';
import '../../repositories/implement/album_images_implement.dart';
import '../../constants/url_api.dart';
import '../models/entity/featured_job_post.dart';
import '../repositories/implement/job_post_skills_implement.dart';

class LikedProvider extends ChangeNotifier {
  bool isLoadingJobPostLiked = false;
  List<StoreImage> albumImagesJobPostLiked = [];
  List<JobPostSkill> listSkillJobPostLiked = [];
  List<FeaturedJobPost> companiesInformationJobPostLiked = [];
  int companiesInformationLengthJobPostLiked = 0;

  bool isLoadingLiked = false;
  List<StoreImage> albumImagesLiked = [];
  List<JobPostSkill> listSkillLiked = [];
  List<FeaturedJobPost> companiesInformationLiked = [];
  int companiesInformationLengthLiked = 0;

  bool isLoadingMatching = false;
  List<StoreImage> albumImagesMatching = [];
  List<JobPostSkill> listSkillMatching = [];
  List<FeaturedJobPost> companiesInformationMatching = [];
  int companiesInformationLengthMatching = 0;

  void getJobPostLiked(String id) async {
    isLoadingJobPostLiked = true;
    companiesInformationJobPostLiked.clear();
    await LikesImplement()
        .getJobPostLiked(
          UrlApi.likes,
          id,
        )
        .then((value) async => {
              companiesInformationLengthJobPostLiked = value.data.length,
              notifyListeners(),
              for (var i = 0; i < value.data.length; i++)
                {
                  if (!value.data[i].match)
                    {
                      await JobPostSkillsImplement()
                          .getJobPostSkillsById(
                              UrlApi.jobPostSkills, value.data[i].jobPost.id)
                          .then(
                              (value) => {listSkillJobPostLiked = value.data}),
                      await AlbumImagesImplement()
                          .getAlbumImagesByJobPostId(
                            UrlApi.albumImages,
                            value.data[i].jobPost.id,
                          )
                          .then((value) =>
                              {albumImagesJobPostLiked = value.data}),
                      companiesInformationJobPostLiked.add(
                        FeaturedJobPost(
                          id: value.data[i].jobPost.id,
                          title: value.data[i].jobPost.title,
                          description: value.data[i].jobPost.description,
                          quantity: value.data[i].jobPost.quantity,
                          companyId: value.data[i].jobPost.companyId,
                          jobPositionId: value.data[i].jobPost.jobPositionId,
                          workingStyleId: value.data[i].jobPost.workingStyleId,
                          workingPlace: value.data[i].jobPost.workingPlace,
                          jobPosition: JobPosition(
                              id: value.data[i].jobPost.jobPositionId,
                              name: ''),
                          workingStyle: WorkingStyle(
                              id: value.data[i].jobPost.workingStyleId,
                              name: ''),
                          albumImages: albumImagesJobPostLiked,
                          jobPostSkills: listSkillJobPostLiked,
                        ),
                      )
                    }
                }
            });
    isLoadingJobPostLiked = false;
    notifyListeners();
  }

  void getLiked(String id) async {
    isLoadingLiked = true;
    companiesInformationLiked.clear();
    await LikesImplement()
        .getLiked(
          UrlApi.likes,
          id,
        )
        .then((value) async => {
              companiesInformationLengthLiked = value.data.length,
              notifyListeners(),
              for (var i = 0; i < value.data.length; i++)
                {
                  if (!value.data[i].match)
                    {
                      await JobPostSkillsImplement()
                          .getJobPostSkillsById(
                              UrlApi.jobPostSkills, value.data[i].jobPost.id)
                          .then((value) => {listSkillLiked = value.data}),
                      await AlbumImagesImplement()
                          .getAlbumImagesByJobPostId(
                            UrlApi.albumImages,
                            value.data[i].jobPost.id,
                          )
                          .then((value) => {albumImagesLiked = value.data}),
                      companiesInformationLiked.add(
                        FeaturedJobPost(
                          id: value.data[i].jobPost.id,
                          title: value.data[i].jobPost.title,
                          description: value.data[i].jobPost.description,
                          quantity: value.data[i].jobPost.quantity,
                          companyId: value.data[i].jobPost.companyId,
                          jobPositionId: value.data[i].jobPost.jobPositionId,
                          workingStyleId: value.data[i].jobPost.workingStyleId,
                          workingPlace: value.data[i].jobPost.workingPlace,
                          jobPosition: JobPosition(
                              id: value.data[i].jobPost.jobPositionId,
                              name: ''),
                          workingStyle: WorkingStyle(
                              id: value.data[i].jobPost.workingStyleId,
                              name: ''),
                          albumImages: albumImagesLiked,
                          jobPostSkills: listSkillLiked,
                        ),
                      )
                    }
                }
            });
    isLoadingLiked = false;
    notifyListeners();
  }

  void getMatching(
    String id,
  ) async {
    isLoadingMatching = true;
    companiesInformationMatching.clear();
    await LikesImplement()
        .getMatching(
          UrlApi.likes,
          id,
        )
        .then((value) async => {
              companiesInformationLengthMatching = value.data.length,
              notifyListeners(),
              for (var i = 0; i < value.data.length; i++)
                {
                  await JobPostSkillsImplement()
                      .getJobPostSkillsById(
                          UrlApi.jobPostSkills, value.data[i].jobPost.id)
                      .then((value) => {listSkillMatching = value.data}),
                  await AlbumImagesImplement()
                      .getAlbumImagesByJobPostId(
                        UrlApi.albumImages,
                        value.data[i].jobPost.id,
                      )
                      .then((value) => {albumImagesMatching = value.data}),
                  companiesInformationMatching.add(
                    FeaturedJobPost(
                      id: value.data[i].jobPost.id,
                      title: value.data[i].jobPost.title,
                      description: value.data[i].jobPost.description,
                      quantity: value.data[i].jobPost.quantity,
                      companyId: value.data[i].jobPost.companyId,
                      jobPositionId: value.data[i].jobPost.jobPositionId,
                      workingStyleId: value.data[i].jobPost.workingStyleId,
                      workingPlace: value.data[i].jobPost.workingPlace,
                      jobPosition: JobPosition(
                          id: value.data[i].jobPost.jobPositionId, name: ''),
                      workingStyle: WorkingStyle(
                          id: value.data[i].jobPost.workingStyleId, name: ''),
                      albumImages: albumImagesMatching,
                      jobPostSkills: listSkillMatching,
                    ),
                  )
                }
            });
    isLoadingMatching = false;
    notifyListeners();
  }
}
