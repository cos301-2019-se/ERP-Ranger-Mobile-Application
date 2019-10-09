import { TestBed } from '@angular/core/testing';

import { RangerRewardService } from './ranger-reward.service';

describe('RangerRewardService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: RangerRewardService = TestBed.get(RangerRewardService);
    expect(service).toBeTruthy();
  });
});
