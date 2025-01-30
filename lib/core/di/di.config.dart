// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/login_view/data/data_sources/remote_data_source/login_remote_data_source.dart'
    as _i685;
import '../../features/login_view/data/data_sources/remote_data_source/login_remote_data_source_impl.dart'
    as _i959;
import '../../features/login_view/data/repositories/login_repository_impl.dart'
    as _i1067;
import '../../features/login_view/domain/repositories/login_repository.dart'
    as _i36;
import '../../features/login_view/domain/use_cases/login_use_case.dart'
    as _i1041;
import '../../features/login_view/presentation/manager/cubit/login_view_model.dart'
    as _i588;
import '../../features/register_view/data/data_sources/remote_data_source/register_remote_data_source.dart'
    as _i1058;
import '../../features/register_view/data/data_sources/remote_data_source/register_remote_data_source_impl.dart'
    as _i5;
import '../../features/register_view/data/repositories/register_repository_impl.dart'
    as _i1014;
import '../../features/register_view/domain/repositories/register_repository.dart'
    as _i240;
import '../../features/register_view/domain/use_cases/register_use_case.dart'
    as _i333;
import '../../features/register_view/presentation/manager/cubit/register_view_model.dart'
    as _i180;
import '../api/api_manager.dart' as _i1047;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i1047.ApiManager>(() => _i1047.ApiManager());
    gh.factory<_i685.LoginRemoteDataSource>(
        () => _i959.LoginRemoteDataSourceImpl());
    gh.factory<_i1058.RegisterRemoteDataSource>(
        () => _i5.RegisterRemoteDataSourceImpl());
    gh.factory<_i240.RegisterRepository>(() => _i1014.RegisterRepositoryImpl(
        registerRemoteDataSource: gh<_i1058.RegisterRemoteDataSource>()));
    gh.factory<_i333.RegisterUseCase>(() => _i333.RegisterUseCase(
        registerRepository: gh<_i240.RegisterRepository>()));
    gh.factory<_i180.RegisterScreenViewModel>(() =>
        _i180.RegisterScreenViewModel(
            registerUseCase: gh<_i333.RegisterUseCase>()));
    gh.factory<_i36.LoginRepository>(() => _i1067.LoginRepositoryImpl(
        loginRemoteDataSource: gh<_i685.LoginRemoteDataSource>()));
    gh.factory<_i1041.LoginUseCase>(
        () => _i1041.LoginUseCase(loginRepository: gh<_i36.LoginRepository>()));
    gh.factory<_i588.LoginScreenViewModel>(() =>
        _i588.LoginScreenViewModel(loginUseCase: gh<_i1041.LoginUseCase>()));
    return this;
  }
}
