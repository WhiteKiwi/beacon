# Contributing

Beacon에 관심을 가져주셔서 감사합니다. 작은 수정은 바로 Pull Request를 열어도 좋고, 동작이나 API가 크게 바뀌는 제안은 먼저 이슈에서 방향을 맞춰 주세요.

## 개발 환경

- iOS: Xcode 26+, iOS 17+
- Server: Node.js 24, pnpm 10.33

```bash
cd server
pnpm install --frozen-lockfile
pnpm test
pnpm build
```

iOS 앱은 `ios/beacon.xcodeproj`를 열어 빌드합니다. Firebase Analytics가 필요하면 Firebase Console에서 내려받은 `GoogleService-Info.plist`를 `ios/beacon/`에 두세요. 이 파일은 커밋하지 않습니다.

## Pull Request

- 하나의 PR에는 하나의 목적만 담습니다.
- 커밋은 `{type}: {imperative summary}` 형식을 사용합니다.
- 위치 정보, API 토큰, 인증서와 같은 민감 정보는 테스트 데이터라도 커밋하지 않습니다.
- UI 또는 API 동작을 바꾸면 관련 문서와 테스트도 함께 갱신합니다.

