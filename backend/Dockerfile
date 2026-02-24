FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["QuranApp.API/QuranApp.API.csproj", "QuranApp.API/"]
COPY ["QuranApp.Application/QuranApp.Application.csproj", "QuranApp.Application/"]
COPY ["QuranApp.Domain/QuranApp.Domain.csproj", "QuranApp.Domain/"]
COPY ["QuranApp.Infrastructure/QuranApp.Infrastructure.csproj", "QuranApp.Infrastructure/"]
RUN dotnet restore "QuranApp.API/QuranApp.API.csproj"
COPY . .
WORKDIR "/src/QuranApp.API"
RUN dotnet build "QuranApp.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "QuranApp.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "QuranApp.API.dll"]