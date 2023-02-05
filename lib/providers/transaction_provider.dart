import 'package:flutter/material.dart';
import 'package:it_job_mobile/models/entity/profile_applicant.dart';
import 'package:it_job_mobile/models/entity/transaction.dart';
import 'package:it_job_mobile/repositories/implement/applicants_implement.dart';
import 'package:it_job_mobile/repositories/implement/profile_applicants_implement.dart';
import 'package:it_job_mobile/repositories/implement/transactions_implement.dart';
import 'package:it_job_mobile/constants/url_api.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../models/entity/applicant.dart';
import '../../models/entity/product.dart';
import '../../shared/applicant_preferences.dart';

class TransactionProvider extends ChangeNotifier {
  List<Product> products = [];
  List<Applicant> applicants = [];
  List<ProfileApplicant> profileApplicants = [];
  List<Transaction> transactions = [];
  bool isLoad = false;

  Future<void> getTransaction() async {
    isLoad = true;
    transactions.clear;
    transactions = [];
    int createBy = 1;
    await ApplicantsImplement()
        .getListApplicant(UrlApi.applicant)
        .then((value) => applicants = value.data);
    notifyListeners();
    await ProfileApplicantsImplement()
        .getProfileApplicantsById(UrlApi.profileApplicants,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
        .then((value) async => {
              profileApplicants = value.data,
              for (var i = 0; i < value.data.length; i++)
                {
                  createBy = i + 1,
                  await TransactionsImplement()
                      .getTransactionJobPosts(
                          UrlApi.transactionJobPosts, value.data[i].id)
                      .then((value) => {
                            for (var j = 0; j < value.data.length; j++)
                              {
                                transactions.add(Transaction(
                                  id: value.data[j].id,
                                  type: value.data[j].typeOfTransaction,
                                  description: "Hồ sơ $createBy",
                                  total: "+ " +
                                      value.data[j].total.toString().substring(
                                          0,
                                          value.data[j].total
                                                  .toString()
                                                  .length -
                                              2),
                                  createDate:
                                      value.data[j].createDate.toLocal(),
                                )),
                              }
                          })
                }
            });
    await TransactionsImplement()
        .getTransactionJobPosts(UrlApi.transactionJobPosts,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
        .then((value) => {
              for (var i = 0; i < value.data.length; i++)
                {
                  for (var j = 0; j < applicants.length; j++)
                    {
                      if (value.data[i].receiver == applicants[j].id)
                        {
                          transactions.add(Transaction(
                            id: value.data[i].id,
                            type: value.data[i].typeOfTransaction,
                            description: applicants[j].name,
                            total: "+ " +
                                value.data[i].total.toString().substring(0,
                                    value.data[i].total.toString().length - 2),
                            createDate: value.data[i].createDate.toLocal(),
                          )),
                        }
                    }
                }
            });
    await TransactionsImplement()
        .getTransactionRewardExchanges(UrlApi.transactions,
            Jwt.parseJwt(ApplicantPreferences.getToken(''))['Id'].toString())
        .then((value) => {
              for (var i = 0; i < value.data.length; i++)
                {
                  transactions.add(Transaction(
                    id: value.data[i].id,
                    type: value.data[i].typeOfTransaction,
                    description: value.data[i].product.name,
                    total: "- " +
                        value.data[i].total.toString().substring(
                            0, value.data[i].total.toString().length - 2),
                    createDate: value.data[i].createDate.toLocal(),
                  )),
                },
            });
    transactions.sort((a, b) {
      return b.createDate.compareTo(a.createDate);
    });
    notifyListeners();
    isLoad = false;
    notifyListeners();
  }
}
