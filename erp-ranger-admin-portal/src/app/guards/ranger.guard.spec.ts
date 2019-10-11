import { TestBed, async, inject } from '@angular/core/testing';

import { RangerGuard } from './ranger.guard';

describe('RangerGuard', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [RangerGuard]
    });
  });

  it('should ...', inject([RangerGuard], (guard: RangerGuard) => {
    expect(guard).toBeTruthy();
  }));
});
