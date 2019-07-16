import { TestBed } from '@angular/core/testing';

import { AddMarkerService } from './add-marker.service';

describe('AddMarkerService', () => {
  beforeEach(() => TestBed.configureTestingModule({}));

  it('should be created', () => {
    const service: AddMarkerService = TestBed.get(AddMarkerService);
    expect(service).toBeTruthy();
  });
});
