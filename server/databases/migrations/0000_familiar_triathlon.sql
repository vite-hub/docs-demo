CREATE TABLE `account` (
	`id` text PRIMARY KEY NOT NULL,
	`accountId` text NOT NULL,
	`providerId` text NOT NULL,
	`userId` text NOT NULL,
	`accessToken` text,
	`refreshToken` text,
	`idToken` text,
	`accessTokenExpiresAt` integer,
	`refreshTokenExpiresAt` integer,
	`scope` text,
	`password` text,
	`createdAt` integer NOT NULL,
	`updatedAt` integer NOT NULL,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `vitehub_content_sessions` (
	`workspace` text NOT NULL,
	`collection` text NOT NULL,
	`document` text NOT NULL,
	`session` text NOT NULL,
	`user_id` text NOT NULL,
	`user_name` text,
	`user_image` text,
	`kind` text NOT NULL,
	`acquired_at` integer,
	`renewed_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`last_input_at` integer,
	PRIMARY KEY(`workspace`, `collection`, `document`, `session`)
);
--> statement-breakpoint
CREATE INDEX `vitehub_content_sessions_expiry` ON `vitehub_content_sessions` (`workspace`,`expires_at`);--> statement-breakpoint
CREATE TABLE `jwks` (
	`id` text PRIMARY KEY NOT NULL,
	`publicKey` text NOT NULL,
	`privateKey` text NOT NULL,
	`createdAt` integer NOT NULL,
	`expiresAt` integer,
	`alg` text,
	`crv` text
);
--> statement-breakpoint
CREATE TABLE `oauthAccessToken` (
	`id` text PRIMARY KEY NOT NULL,
	`token` text,
	`clientId` text NOT NULL,
	`sessionId` text,
	`userId` text,
	`referenceId` text,
	`authorizationCodeId` text,
	`resources` text,
	`requestedUserInfoClaims` text,
	`refreshId` text,
	`expiresAt` integer,
	`createdAt` integer,
	`revoked` integer,
	`confirmation` text,
	`scopes` text NOT NULL,
	FOREIGN KEY (`clientId`) REFERENCES `oauthClient`(`clientId`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`sessionId`) REFERENCES `session`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`refreshId`) REFERENCES `oauthRefreshToken`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `oauthAccessToken_token_unique` ON `oauthAccessToken` (`token`);--> statement-breakpoint
CREATE TABLE `oauthClient` (
	`id` text PRIMARY KEY NOT NULL,
	`clientId` text NOT NULL,
	`clientSecret` text,
	`clientDiscoveryId` text,
	`disabled` integer,
	`skipConsent` integer,
	`enableEndSession` integer,
	`subjectType` text,
	`scopes` text,
	`clientCredentialsScopes` text,
	`userId` text,
	`createdAt` integer,
	`updatedAt` integer,
	`name` text,
	`uri` text,
	`icon` text,
	`contacts` text,
	`tos` text,
	`policy` text,
	`softwareId` text,
	`softwareVersion` text,
	`softwareStatement` text,
	`redirectUris` text NOT NULL,
	`postLogoutRedirectUris` text,
	`backchannelLogoutUri` text,
	`backchannelLogoutSessionRequired` integer,
	`tokenEndpointAuthMethod` text,
	`applicationType` text,
	`jwks` text,
	`jwksUri` text,
	`grantTypes` text,
	`responseTypes` text,
	`requirePKCE` integer,
	`dpopBoundAccessTokens` integer,
	`referenceId` text,
	`metadata` text,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `oauthClient_clientId_unique` ON `oauthClient` (`clientId`);--> statement-breakpoint
CREATE TABLE `oauthClientAssertion` (
	`id` text PRIMARY KEY NOT NULL,
	`expiresAt` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `oauthClientResource` (
	`id` text PRIMARY KEY NOT NULL,
	`clientId` text NOT NULL,
	`resourceId` text NOT NULL,
	`metadata` text,
	`createdAt` integer,
	FOREIGN KEY (`clientId`) REFERENCES `oauthClient`(`clientId`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`resourceId`) REFERENCES `oauthResource`(`identifier`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `oauthConsent` (
	`id` text PRIMARY KEY NOT NULL,
	`clientId` text NOT NULL,
	`userId` text,
	`referenceId` text,
	`resources` text,
	`requestedUserInfoClaims` text,
	`scopes` text NOT NULL,
	`createdAt` integer,
	`updatedAt` integer,
	FOREIGN KEY (`clientId`) REFERENCES `oauthClient`(`clientId`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `oauthRefreshToken` (
	`id` text PRIMARY KEY NOT NULL,
	`token` text NOT NULL,
	`clientId` text NOT NULL,
	`sessionId` text,
	`userId` text NOT NULL,
	`referenceId` text,
	`authorizationCodeId` text,
	`resources` text,
	`requestedUserInfoClaims` text,
	`expiresAt` integer,
	`createdAt` integer,
	`revoked` integer,
	`rotatedAt` integer,
	`rotationReplayResponse` text,
	`rotationReplayExpiresAt` integer,
	`authTime` integer,
	`confirmation` text,
	`scopes` text NOT NULL,
	FOREIGN KEY (`clientId`) REFERENCES `oauthClient`(`clientId`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`sessionId`) REFERENCES `session`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `oauthRefreshToken_token_unique` ON `oauthRefreshToken` (`token`);--> statement-breakpoint
CREATE TABLE `oauthResource` (
	`id` text PRIMARY KEY NOT NULL,
	`identifier` text NOT NULL,
	`name` text NOT NULL,
	`accessTokenTtl` integer,
	`refreshTokenTtl` integer,
	`signingAlgorithm` text,
	`signingKeyId` text,
	`allowedScopes` text,
	`customClaims` text,
	`dpopBoundAccessTokensRequired` integer,
	`disabled` integer,
	`createdAt` integer,
	`updatedAt` integer,
	`policyVersion` integer,
	`metadata` text
);
--> statement-breakpoint
CREATE UNIQUE INDEX `oauthResource_identifier_unique` ON `oauthResource` (`identifier`);--> statement-breakpoint
CREATE TABLE `session` (
	`id` text PRIMARY KEY NOT NULL,
	`expiresAt` integer NOT NULL,
	`token` text NOT NULL,
	`createdAt` integer NOT NULL,
	`updatedAt` integer NOT NULL,
	`ipAddress` text,
	`userAgent` text,
	`userId` text NOT NULL,
	`impersonatedBy` text,
	FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `session_token_unique` ON `session` (`token`);--> statement-breakpoint
CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`emailVerified` integer NOT NULL,
	`image` text,
	`createdAt` integer NOT NULL,
	`updatedAt` integer NOT NULL,
	`role` text,
	`banned` integer,
	`banReason` text,
	`banExpires` integer
);
--> statement-breakpoint
CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);--> statement-breakpoint
CREATE TABLE `verification` (
	`id` text PRIMARY KEY NOT NULL,
	`identifier` text NOT NULL,
	`value` text NOT NULL,
	`expiresAt` integer NOT NULL,
	`createdAt` integer NOT NULL,
	`updatedAt` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `vitehub_comment_forge` (
	`id` text PRIMARY KEY NOT NULL,
	`thread_id` text,
	`repository` text NOT NULL,
	`pull_request` integer NOT NULL,
	`remote_id` text,
	`node_id` text,
	`url` text,
	`digest` text,
	`posted_as` text,
	`minimized` integer DEFAULT false NOT NULL,
	`error` text,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `vitehub_comment_forge_thread` ON `vitehub_comment_forge` (`thread_id`);--> statement-breakpoint
CREATE INDEX `vitehub_comment_forge_pull_request` ON `vitehub_comment_forge` (`repository`,`pull_request`);--> statement-breakpoint
CREATE TABLE `vitehub_comment_scope_counters` (
	`scope` text PRIMARY KEY NOT NULL,
	`last_number` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `vitehub_comment_threads` (
	`id` text PRIMARY KEY NOT NULL,
	`scope` text DEFAULT 'pages' NOT NULL,
	`number` integer DEFAULT 0 NOT NULL,
	`page` text NOT NULL,
	`anchor` text NOT NULL,
	`context` text,
	`metadata` text,
	`status` text NOT NULL,
	`created_by` text NOT NULL,
	`resolved_by` text,
	`resolved_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL
);
--> statement-breakpoint
CREATE INDEX `vitehub_comment_threads_page` ON `vitehub_comment_threads` (`page`,`status`);--> statement-breakpoint
CREATE UNIQUE INDEX `vitehub_comment_threads_number` ON `vitehub_comment_threads` (`scope`,`number`);--> statement-breakpoint
CREATE INDEX `vitehub_comment_threads_updated` ON `vitehub_comment_threads` (`updated_at`);--> statement-breakpoint
CREATE TABLE `vitehub_comments` (
	`id` text PRIMARY KEY NOT NULL,
	`thread_id` text NOT NULL,
	`body` text NOT NULL,
	`mentions` text NOT NULL,
	`author` text NOT NULL,
	`created_at` integer NOT NULL,
	`edited_at` integer,
	FOREIGN KEY (`thread_id`) REFERENCES `vitehub_comment_threads`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `vitehub_comments_thread` ON `vitehub_comments` (`thread_id`,`created_at`);