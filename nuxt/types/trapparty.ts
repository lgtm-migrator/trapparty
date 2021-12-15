export interface CharityOrganization {
  id: number
  name: string
  url: string
}

export interface Event {
  id: number
  commonDonationAmount: number
  commonDonationIsLive: boolean
  commonDonationUrl: string
  discordInviteCode: string
  end: Date
  name: string
  start: Date
  streamUrl: URL
}

export enum GameType {
  RANDOM_FACTS = 'RANDOM_FACTS',
  TEAM_SCORE = 'TEAM_SCORE',
}

export interface Game {
  id: number
  eventId: number
  isActive: boolean
  name: string
  type: GameType
}

export interface GameRandomFactsRound {
  id: number
  answerCorrect: number
  gameId: number
  questionerName: string
}

export interface GameRandomFactsVote {
  id: number
  answer: number
  playerId: number
  roundId: number
}

export interface Player {
  id: number
  invitationCode: string
  name: string
  teamId: number
}

export interface Team {
  id: number
  donationAmount: number
  name: string
}
