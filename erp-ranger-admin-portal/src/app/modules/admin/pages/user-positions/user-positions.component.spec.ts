import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { UserPositionsComponent } from './user-positions.component';

describe('UserPositionsComponent', () => {
  let component: UserPositionsComponent;
  let fixture: ComponentFixture<UserPositionsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ UserPositionsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(UserPositionsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
