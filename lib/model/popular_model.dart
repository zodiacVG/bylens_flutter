//用于测试的，流行榜model  注意这是一个小项目的model

class popularTmdb {
  bool adult;
  String backdropPath;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  String releaseDate;
  String title;
  bool video;
  double voteAverage; //因为有的评分是小数，有的是整数
  int voteCount;

  popularTmdb(
      {this.adult,
        this.backdropPath,
        this.genreIds,
        this.id,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.releaseDate,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount});

  popularTmdb.fromJson(Map<String, dynamic> json) {
    adult = json['adult'];
    if(json['backdrop_path']==null){
      backdropPath='/v7baGyne7CsLxnM2maMwIxKZdVF.jpg'; //默认背景
    }else{
      backdropPath=json['backdrop_path'];
    }
    genreIds = json['genre_ids'].cast<int>();
    id = json['id'];
    originalLanguage = json['original_language'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    popularity = json['popularity'];
    posterPath = json['poster_path'];
    if(json['release_date']==null){
      releaseDate='Unknow';
    }else{
      releaseDate=json['release_date'];
    }
    title = json['title'];
    video = json['video'];
    voteAverage = json['vote_average']/1.0;
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this.adult;
    data['backdrop_path'] = this.backdropPath;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_language'] = this.originalLanguage;
    data['original_title'] = this.originalTitle;
    data['overview'] = this.overview;
    data['popularity'] = this.popularity;
    data['poster_path'] = this.posterPath;
    data['release_date'] = this.releaseDate;
    data['title'] = this.title;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    data['vote_count'] = this.voteCount;
    return data;
  }
}
